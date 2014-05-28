<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="ead"
    version="2.0">
 
<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="utf-8" />

<!-- Tab variable for creating TSV file -->
<xsl:variable name="tab">
    <xsl:text>&#x09;</xsl:text>
</xsl:variable>

<!-- New Line variable for creating new rows in TSV file -->
<xsl:variable name="newline">
    <xsl:text>&#xa;</xsl:text>
</xsl:variable>

<!--
<xsl:template match="/">
    <xsl:text>eadid</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>title</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>url</xsl:text>
    <xsl:value-of select="$newline"/> 
-->
     
<!-- Loads all ead files in directory and creates tabbed file of info -->
 
<xsl:template match="/">

<xsl:element name="data">
  
 <xsl:for-each select="collection('file:/c:/Users/nh48/Documents/GitHub/ead-test/2_schema_valid_EADs/?select=*.xml')">

 <record>
 <eadid><xsl:value-of select="normalize-space(ead:ead/ead:eadheader/ead:eadid)"/></eadid>
 <title><xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:unittitle)"/></title>  
 <url><xsl:value-of select="normalize-space(ead:ead/ead:eadheader/ead:eadid/@url)"/></url>
 <filename_base><xsl:value-of select="replace(base-uri(),'file:/c:/Users/nh48/Documents/GitHub/ead-test/2_schema_valid_EADs/(.*)\.xml','$1')"/></filename_base>   
 <rlid><xsl:text>rlid_goes_here</xsl:text></rlid>
 </record>
 
 </xsl:for-each>
</xsl:element>

</xsl:template>
</xsl:stylesheet>