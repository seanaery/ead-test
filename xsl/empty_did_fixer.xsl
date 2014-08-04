<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns="urn:isbn:1-931666-22-9" 
  exclude-result-prefixes="ead xsi xs">

  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <!--Identity template to copy entire EAD source document -->
  <xsl:template match="@*|node()" name="identity">
    <!-- identity transform is default -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
 <!-- Fixes cases (843) where there is no unittitle or unitdate inside did.  These will not migrate to AS 
 Examples: btv, uaposter, etc.) -->
  
  <xsl:template match="ead:c01//ead:did[not(ead:unittitle or ead:unitdate)]">
    <xsl:element name="did">
      <xsl:element name="unittitle">
        <xsl:value-of select="ead:container/@type"/><xsl:text> </xsl:text><xsl:value-of select="ead:container"/>
      </xsl:element>
      <xsl:apply-templates select="ead:container|ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
    </xsl:element>  
  </xsl:template>
  
  
 
 
 
  <!-- GENERAL UTILITIES -->
  
  <!-- String replace template; see https://gist.github.com/ijy/6572481  -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
            select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

</xsl:stylesheet>
