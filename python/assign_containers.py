from lxml import etree
from copy import deepcopy
import glob
import os

NSMAP = {
    'ead' : 'urn:isbn:1-931666-22-9',
}

containers = []


class Delver(object):
    
    current_container = None
    containers = []

    def reset(self):
        self.current_container = None

    def delve(self, node, level = 1):
        """
        tnode = node.find('ead:did/ead:unittitle/ead:title', namespaces=NSMAP)
        if tnode is not None:
            title = tnode.text.strip().lstrip()
        else:
            title = node.find('ead:did/ead:unittitle', namespaces=NSMAP).text.strip().lstrip()
        """

        thislevel = level + 1
        nextlevel = thislevel + 1
        is_leaf = False
        children = node.xpath('ead:c0' + str(nextlevel), namespaces=NSMAP)
        if len(children) == 0:
            is_leaf = True

        xpath = 'ead:c0' + str(thislevel)
        subseries = node.xpath(xpath, namespaces=NSMAP)
        c = node.find('ead:did/ead:container', namespaces=NSMAP)
        boxnodes = node.xpath('ead:did/ead:container[@type="box"]', namespaces=NSMAP)
        filenodes = node.xpath('ead:did/ead:container[@type="file"]', namespaces=NSMAP)

        if is_leaf and len(boxnodes) == 0 and self.current_container is not None:
            self.containers.append((node, self.current_container))
        elif len(boxnodes) == 1:
            self.current_container = boxnodes[0]

        """
        if self.current_container is not None:
            cstr = self.current_container.get('type') + ' ' + self.current_container.text
            t = ' '.join(title[:10].split())
            print str(thislevel) + ',' + str(len(subseries)) + ',' + cstr + ' -' + t 
        else:    
            print str(thislevel) + ',' + str(len(subseries))
            pass
        """
        for s in subseries:
            self.delve(s, thislevel)


files = glob.glob('../3_processed_EADs/*.xml')
INV_XML_PATH = '/Users/wsexton/Data/xml/ead'    

pattern = '//ead:c0{INT}[not(@level)]'
patterns = [pattern.format(INT=i) for i in range(1,10)]
XPATH_c0x_WITH_NO_LEVEL = '|'.join(patterns)


def file_filter(x):
    if not x.endswith('.xml'):
        return False
    invid = x[x.rfind('/')+1:-4]
    outpath = '../4_finalized_EADs/' + invid + '.xml'
    if not os.path.exists(outpath):
        return True
    return False

files = filter(file_filter, files)
#files = filter(lambda x: x.endswith('baumol.xml'), files)

for f in files:
    
    invid = f[f.rfind('/')+1:-4]
    print invid
    """
    outpath = None
    for stem in ['rbmscl','toolkit']:
        testpath = INV_XML_PATH + '/' + stem + '/' + invid + '.xml'
        if os.path.exists(testpath):
            outpath = '../4_finalized_EADs/' + stem + '/' + invid + '.xml'
            break
    """
    outpath = '../4_finalized_EADs/' + invid + '.xml'

    if os.path.exists(outpath):
        continue
                
    invroot = etree.parse('../3_processed_EADs/' + invid + '.xml').getroot()
    c01list = invroot.xpath('//ead:c01', namespaces=NSMAP)
    delver = Delver()
    for c01 in c01list:
        #title = c01.find('ead:did/ead:unittitle', namespaces=NSMAP).text.strip()
        #print title
        #delver.reset()    
        delver.delve(c01)
    
    for (component, container) in delver.containers:
        if container is None:
            continue
        newcontainer = deepcopy(container)
        did = component.find('ead:did', namespaces=NSMAP)
        did.append(newcontainer)
    
    c0x_WITH_NO_LEVEL = invroot.xpath(XPATH_c0x_WITH_NO_LEVEL, namespaces=NSMAP)
    for c in c0x_WITH_NO_LEVEL:
        c.set('level', 'file')
        
    out = open(outpath, 'w')
    out.write(etree.tostring(invroot))
    out.close()
