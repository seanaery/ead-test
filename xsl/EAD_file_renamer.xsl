<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns="urn:isbn:1-931666-22-9" 
  exclude-result-prefixes="ead xsi xs">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!--Identity template to copy entire EAD source document -->
  <xsl:template match="@*|node()" name="identity">
    <!-- identity transform is default -->
 
 <!-- THIS DOES NOT WORK -->
   
 <xsl:result-document href="{//ead:archdesc/ead:did/ead:unitid}.xml">
   <xsl:copy>
   <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
 </xsl:result-document>
      
 


   
  </xsl:template>
  
   

</xsl:stylesheet>
