from lxml import etree
import glob

NSMAP = {
    'ead' : 'urn:isbn:1-931666-22-9',
}

g = glob.glob('../3_processed_EADs/*.xml')
print len(g)
for f in g:
    invroot = etree.parse(f)
    print invroot.get(

