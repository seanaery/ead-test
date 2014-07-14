<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="ead"
    version="2.0">

<xsl:output method="text" omit-xml-declaration="yes" encoding="utf-8"/>

<xsl:strip-space elements="*"/>


    <xsl:variable name="tab">
        <xsl:text>&#x09;</xsl:text>
    </xsl:variable>

    <xsl:variable name="newline">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>


<xsl:template match="/">
    
<!-- Column Headers
    
    <xsl:text>EADID</xsl:text>
    <xsl:value-of select="$tab"/>
    
    <xsl:text>container_type_attribute_value</xsl:text>
    <xsl:value-of select="$tab"/>
    
    <xsl:text>container_label_attribute_value</xsl:text>
    <xsl:value-of select="$tab"/>
    
     <xsl:text>container_tag_value</xsl:text>
    
<xsl:value-of select="$newline"/>

   -->
    
<!-- Begin Data Rows -->


    <xsl:for-each select="collection('file:/c:/Users/nh48/Documents/GitHub/ead-test/3_processed_EADs/?select=*.xml')//ead:container">
    <xsl:value-of select="ancestor::ead:ead//ead:eadid"/><xsl:value-of select="$tab"/>
    <xsl:value-of select="./@type"/><xsl:value-of select="$tab"/>
    <xsl:value-of select="./@label"/><xsl:value-of select="$tab"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="$newline"/>
</xsl:for-each>
    
</xsl:template>

</xsl:stylesheet>