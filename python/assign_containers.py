from lxml import etree
from copy import deepcopy
import glob, os, csv

NSMAP = {
    'ead' : 'urn:isbn:1-931666-22-9',
}


BOX_TYPES = ['Box', 'box', 'Oversize-Box', 'oversizebox', 'opaperfolder', 'oversizecabinet']

XPATH_BOX_TYPES = '|'.join(['ead:container[@type="' + b + '"]' for b in BOX_TYPES])

def get_container_inheritance_map():
    fieldnames = ['container type',' occurrence', 'Inherit_Box_if_not_present?']
    f = open('container_type_report.csv', 'rU')
    reader = csv.DictReader(f, fieldnames)
    cimap = {}
    for r in reader:
        ctype = r['container type']
        yorn = r['Inherit_Box_if_not_present?']
        if yorn == 'Yes':
            cimap[ctype] = True
        elif yorn == 'No':
            cimap[ctype] = False
        else:
            continue
    return cimap

class Delver(object):
    
    def __init__(self, container_inheritance_map):
        self.container_inheritance_map = container_inheritance_map
        self.containers = []
        self.current_box = None

    def reset(self):
        self.current_box = None

    def delve(self, node, level = 1):
        """
        tnode = node.find('ead:did/ead:unittitle/ead:title', namespaces=NSMAP)
        if tnode is not None:
            title = tnode.text.strip().lstrip()
        else:
            title = node.find('ead:did/ead:unittitle', namespaces=NSMAP).text.strip().lstrip()
        """

        thislevel = level + 1
        #nextlevel = thislevel + 1
        is_leaf = False
        #xp = 'ead:c0' + str(nextlevel)
        xp = 'ead:c0' + str(thislevel)
        
        children = node.xpath(xp, namespaces=NSMAP)
        if len(children) == 0:
            is_leaf = True

        xpath = 'ead:c0' + str(thislevel)
        subseries = node.xpath(xpath, namespaces=NSMAP)
        did = node.find('ead:did', namespaces=NSMAP)
        if did is None:
            for s in subseries:
                self.delve(s, thislevel)
            return
    
        #if len(containermap) > 1:
        #    print containermap

        
        boxnodes = did.xpath(XPATH_BOX_TYPES, namespaces=NSMAP)
        containerlist = did.xpath('ead:container', namespaces=NSMAP)

        if is_leaf and len(boxnodes) == 0 and self.current_box is not None:
            self.containers.append((node, self.current_box))

            """
            if len(othernodes) > 0:
                for n in othernodes:
                    ntype = n.get('type')
                    if self.container_inheritance_map[ntype] and ntype != self.current_box.get('type'):
                        self.containers.append((node, self.current_box))
                        break
            else:
                self.containers.append((node, self.current_box))
            if len(containerlist) == 1:
                self.current_box = containerlist[0]
            elif len(containerlist) > 1:
                for c in containerlist:
                    if c.get('type') in BOX_TYPES:
                        self.current_box = c
                        break
            """
        elif len(boxnodes) == 1:
            self.current_box = boxnodes[0]
        """
        elif len(containerlist) > 1:
            for c in containerlist:
                if c.get('type') in BOX_TYPES:
                    self.current_box = c
                    break
        
        if self.current_box is not None:
            cstr = self.current_box.get('type') + ' ' + self.current_box.text
            t = ' '.join(title[:10].split())
            print str(thislevel) + ',' + str(len(subseries)) + ',' + cstr + ' -' + t 
        else:    
            print str(thislevel) + ',' + str(len(subseries))
            pass
        """
        for s in subseries:
            self.delve(s, thislevel)

container_inherits_box = get_container_inheritance_map()

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
#files = files[:10]
files = filter(lambda x: x.endswith('whitener.xml') or x.endswith('matthews.xml'), files)

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
    delver = Delver(container_inherits_box)
    #delver.containers = []
    for c01 in c01list:
        #title = c01.find('ead:did/ead:unittitle', namespaces=NSMAP).text.strip()
        #print title
        #delver.reset()    
        delver.delve(c01)
    
    for (component, container) in delver.containers:
        if container is None:
            continue
        boxnode = deepcopy(container)
        newchildren = [boxnode]

        did = component.find('ead:did', namespaces=NSMAP)
        #did.append(boxnode)
        #title = did.find('ead:unittitle/ead:title', namespaces=NSMAP)
        #if title is not None and title.text == 'Mesa Educator,':
        #    print etree.tostring(did)
        othercontainers = did.xpath('ead:container[not(@type="box")]', namespaces=NSMAP)        
        for other in othercontainers:
            newchildren.append(deepcopy(other))
            did.remove(other)
        for newchild in newchildren:
            did.append(newchild)
        #if title is not None and title.text == 'Mesa Educator,':
        #    print etree.tostring(did)
    
    c0x_WITH_NO_LEVEL = invroot.xpath(XPATH_c0x_WITH_NO_LEVEL, namespaces=NSMAP)
    for c in c0x_WITH_NO_LEVEL:
        c.set('level', 'file')
        
    out = open(outpath, 'w')
    out.write(etree.tostring(invroot))
    out.close()
