<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    version="2.0"
    exclude-result-prefixes="xsl ead">
    
    
<xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8"/>

<!-- Tab variable for creating TSV file -->
<xsl:variable name="tab">
    <xsl:text>&#x09;</xsl:text>
</xsl:variable>

<!-- New Line variable for creating new rows in TSV file -->
<xsl:variable name="newline">
    <xsl:text>&#xa;</xsl:text>
</xsl:variable>

<xsl:template match="/">
    <xsl:text>eadid</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>aleph_num</xsl:text>
    <xsl:value-of select="$newline"/> 


<!-- This is what XML looks like 
        
          <notestmt>
            <note>
               <p>This finding aid is NCEAD compliant.</p>
            </note>
            <note>
               <p>Aleph Number: <num type="aleph">002683939</num>
               </p>
            </note>
         </notestmt>
         
 -->
 
<!-- Loads all ead files in directory and creates tabbed file of info -->
    
    <!-- <xsl:for-each select="collection('file:/c:/Users/nh48/Documents/GitHub/ead-test/2_schema_valid_EADs/?select=*.xml')"> -->
        
    <xsl:for-each select="collection('file:/c:/Users/nh48/Documents/GitHub/ead-test/2_schema_valid_EADs/?select=*.xml')">

        <xsl:for-each select="//ead:notestmt/ead:note[ead:p/ead:num]">
        <xsl:value-of select="//ead:eadid"/>
        <xsl:value-of select="$tab"/>
        <xsl:text>Aleph Number: </xsl:text><xsl:element name="num"><xsl:attribute name="type">aleph</xsl:attribute><xsl:value-of select="ead:p/ead:num"/></xsl:element>
         <xsl:value-of select="$newline"/>
    </xsl:for-each>
    </xsl:for-each>
</xsl:template>    
</xsl:stylesheet>