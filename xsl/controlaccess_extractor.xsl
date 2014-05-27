<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    version="2.0">
 
<xsl:output method="text" omit-xml-declaration="yes" encoding="utf-8"/>

<!-- Tab variable for creating TSV file -->
<xsl:variable name="tab">
    <xsl:text>&#x09;</xsl:text>
</xsl:variable>

<!-- New Line variable for creating new rows in TSV file -->
<xsl:variable name="newline">
    <xsl:text>&#xa;</xsl:text>
</xsl:variable>

<xsl:template match="/">
    <xsl:text>original_term</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>cleaned_term</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>term_type</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>eadid_term_source</xsl:text>
    <xsl:value-of select="$newline"/> 
     
 
<!-- Loads all ead files in directory and creates tabbed file of info -->
    <xsl:for-each select="collection('file:/c:/Users/nh48/Documents/GitHub/ead-test/2_schema_valid_EADs/?select=*.xml')">

        <xsl:for-each select="//ead:controlaccess//ead:persname|
            //ead:controlaccess//ead:famname|
            //ead:controlaccess//ead:corpname|
            //ead:controlaccess//ead:geogname|
            //ead:controlaccess//ead:genreform|
            //ead:controlaccess//ead:subject">

         <xsl:value-of select="normalize-space(.)"/>
         <xsl:value-of select="$tab"/>
         <xsl:text>new_term</xsl:text> <!-- placeholder for new term -->
         <xsl:value-of select="$tab"/>
        <xsl:value-of select="local-name()"/> <!-- type of heading -->
        <xsl:value-of select="$tab"/>
         <xsl:value-of select="//ead:eadid"/>
         <xsl:value-of select="$newline"/>
    </xsl:for-each>
    </xsl:for-each>
</xsl:template>    
</xsl:stylesheet>