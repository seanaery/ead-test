<xsl:stylesheet version="1.0" 
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
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
    <!-- CONTAINER INHERITANCE ERROR FIXES BELOW -->


  
  <!-- efolders and anything else -->
  <xsl:template match="//ead:did[ead:container[@type='efolder']][ead:container[not(@type='efolder')]]">
  <xsl:element name="did">
    <xsl:apply-templates select="ead:container[@type='efolder']"/>
    <xsl:apply-templates select="ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
  </xsl:element>    
  </xsl:template>
  
    
  <!--volume and anything else -->
  <xsl:template match="//ead:did[ead:container[@type='volume']][ead:container[not(@type='volume')]]">
    <xsl:element name="did">
      <xsl:apply-templates select="ead:container[@type='volume']"/>
      <xsl:apply-templates select="ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
    </xsl:element>    
  </xsl:template>
  
  <!-- tube and anything else -->
  <xsl:template match="//ead:did[ead:container[@type='tube']][ead:container[not(@type='tube')]]">
    <xsl:element name="did">
      <xsl:apply-templates select="ead:container[@type='tube']"/>
      <xsl:apply-templates select="ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
    </xsl:element>    
  </xsl:template>
  
  <!-- reorder videocassette and box -->
  <xsl:template match="//ead:did[ead:container[@type='videocassette']][ead:container[@type='box']]">
    <xsl:element name="did">
      <xsl:apply-templates select="ead:container[@type='box']"/>
      <xsl:apply-templates select="ead:container[@type='videocassette']"/>
      <xsl:apply-templates select="ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
    </xsl:element>    
  </xsl:template>
  
  <!-- reorder audiocassette and box -->
  <xsl:template match="//ead:did[ead:container[@type='audiocassette']][ead:container[@type='box']]">
    <xsl:element name="did">
      <xsl:apply-templates select="ead:container[@type='box']"/>
      <xsl:apply-templates select="ead:container[@type='audiocassette']"/>
      <xsl:apply-templates select="ead:unittitle|ead:unitdate|ead:physdesc|ead:unitid|ead:physloc|ead:dao|ead:langmaterial|ead:note"/>
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
