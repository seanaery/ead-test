from lxml import etree
import glob
from copy import deepcopy

NSMAP = {
    'ead' : 'urn:isbn:1-931666-22-9',
}

g = glob.glob('../3_processed_EADs/*.xml')


pattern = '//ead:c0{INT}'
patterns = [pattern.format(INT=i) for i in range(1,10)]
XPATH_c0x = '|'.join(patterns)

pattern = 'ead:c0{INT}'
patterns = [pattern.format(INT=i) for i in range(1,10)]
XPATH_c0x_CHILD = '|'.join(patterns)

pattern = '//ead:c0{INT}[not(ead:did/ead:container)][not({XPATH_c0x_CHILD})]'
patterns = [pattern.format(INT = i, XPATH_c0x_CHILD = XPATH_c0x_CHILD) for i in range(1,10)]
XPATH_c0x_WITHOUT_CONTAINER = '|'.join(patterns)

#files = g
files = g[:10]
files = filter(lambda x: x.endswith('dukejb.xml'), g)

for f in files:
    invroot = etree.parse(f).getroot()
    n = invroot.find('ead:eadheader/ead:eadid', namespaces=NSMAP)
    invid = n.text
    c0nodes = invroot.xpath(XPATH_c0x, namespaces=NSMAP)
    c0nodes2 = invroot.xpath(XPATH_c0x_WITHOUT_CONTAINER, namespaces=NSMAP)
    print (invid, len(c0nodes), len(c0nodes2))
    for n in c0nodes2:
        # handle the first priority case:
        # component has a preceding sibling with a container
        x = n.xpath('preceding-sibling::*[ead:did/ead:container][1]', namespaces=NSMAP)
        if len(x) > 0:
            container = x[0].find('ead:did/ead:container', namespaces=NSMAP)
            did = n.find('ead:did', namespaces=NSMAP)
            c = deepcopy(container)
            did.append(c)
            continue


        x = n.xpath('parent::*[ead:did/ead:container][1]', namespaces=NSMAP)
        if len(x) > 0:
            container = x[0].find('ead:did/ead:container', namespaces=NSMAP)
            did = n.find('ead:did', namespaces=NSMAP)
            c = deepcopy(container)
            did.append(c)
            continue

        x = n.xpath('parent::*/ancestor::*[ead:did/ead:container][1]', namespaces=NSMAP)
        if len(x) > 0:
            container = x[0].find('ead:did/ead:container', namespaces=NSMAP)
            did = n.find('ead:did', namespaces=NSMAP)
            c = deepcopy(container)
            did.append(c)
            continue
            

    out = open('../4_finalized_EADs/' + invid + '.xml', 'w')
    out.write(etree.tostring(invroot))
    out.close()
    #break