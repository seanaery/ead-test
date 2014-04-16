<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns="urn:isbn:1-931666-22-9" 
  exclude-result-prefixes="ead xsi xs">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


  <!--Identity template to copy entire EAD document -->
  <xsl:template match="@*|node()" name="identity">
    <!-- identity transform is default -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ArchivesSpace seems to have trouble with empty anythings.  Borrowed this code from UVA_as_munger.xsl  -->
  <xsl:template match="@*[normalize-space()='']"/>
  <!-- don't copy null attributes -->
  <xsl:template match="ead:unitdate[normalize-space()='']"/>
  <!-- don't copy empty unitdates -->
  <xsl:template match="ead:physloc[normalize-space()='']"/>
  <!-- don't copy empty physloc -->


<!-- EAD HEADER -->
  
  <!-- normalizes eadheader attributes and adds revisiondesc to record processing by dtd2schema dn AT-import-fixer.xsl -->
  <xsl:template match="ead:eadheader">
    <xsl:element name="ZZZeadheaderZZZ">
      <xsl:attribute name="findaidstatus">published</xsl:attribute>
      <xsl:attribute name="repositoryencoding">iso15511</xsl:attribute>
      <xsl:attribute name="countryencoding">iso3166-1</xsl:attribute>
      <xsl:attribute name="dateencoding">iso8601</xsl:attribute>
      <xsl:attribute name="langencoding">iso639-2b</xsl:attribute>
      
      <xsl:apply-templates select="ead:eadid|ead:filedesc|ead:profiledesc"/>
      
      <xsl:choose>
        <xsl:when test="ead:revisiondesc">
          <xsl:element name="revisiondesc">
            <xsl:element name="change">
              <xsl:element name="date">2014</xsl:element>
              <xsl:element name="item">Converted from dtd to schema and transformed with AT-import-fixer.xsl</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="ead:revisiondesc/ead:change"/>
          </xsl:element>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:element name="revisiondesc">
            <xsl:element name="change">
              <xsl:element name="date">2014</xsl:element>
              <xsl:element name="item">Converted from dtd to schema and transformed with AT-import-fixer.xsl</xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>  
  </xsl:template>




<!-- Set status of all finding aids to Published -->
  <xsl:template match="@findaidstatus[parent::ead:eadheader]">
    <xsl:attribute name="findaidstatus">
      <xsl:value-of select=" 'published' "/>
    </xsl:attribute>
  </xsl:template>

  <!--Changes eadid countrycode from us to US-->
  <xsl:template match="@countrycode[parent::ead:eadid]">
    <xsl:attribute name="countrycode">
      <xsl:value-of select=" 'US' "/>
    </xsl:attribute>
  </xsl:template>

  <!--Changes eadid mainagencycode from ndd to US-NcD-->
  <xsl:template match="@mainagencycode[parent::ead:eadid]">
    <xsl:attribute name="mainagencycode">
      <xsl:value-of select=" 'US-NcD' "/>
    </xsl:attribute>
  </xsl:template>

    
  <!-- Remove date tagging from titleproper -->
  <xsl:template match="ead:filedesc/ead:titlestmt/ead:titleproper">
    <xsl:element name="titleproper">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ead:filedesc/ead:titlestmt/ead:author">
    <xsl:element name="author">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>


  <!-- Publication Statement - Standardizes publisher statement, accounting for adf, ua, and RL -->
  <xsl:template match="ead:filedesc/ead:publicationstmt">
    <xsl:choose>
      <xsl:when test="ancestor::ead:ead/ead:eadheader/ead:eadid[starts-with(.,'adf')]">
        <xsl:element name="publicationstmt">
          <xsl:element name="publisher">
            <xsl:value-of select="'American Dance Festival Archives'"/>
          </xsl:element>
          <xsl:element name="address">
            <xsl:element name="addressline">Box 90772</xsl:element>
            <xsl:element name="addressline">Durham, NC 27708-0772 U.S.A.</xsl:element>
            <xsl:element name="addressline">919-684-6402</xsl:element>
            <xsl:element name="addressline">adfarchives@americandancefestival.org</xsl:element>
          </xsl:element>
          <xsl:element name="date">
            <xsl:value-of select="normalize-space(translate(ead:p/ead:date,'©',''))"/>
          </xsl:element>
        </xsl:element>

      </xsl:when>

      <xsl:when test="ancestor::ead:ead/ead:eadheader/ead:eadid[starts-with(.,'ua')]">
        <xsl:element name="publicationstmt">
          <xsl:element name="publisher">
            <xsl:value-of select="'Duke University. University Archives'"/>
          </xsl:element>
          <xsl:element name="address">
            <xsl:element name="addressline">Duke University</xsl:element>
            <xsl:element name="addressline">Durham, NC 27708-0185 U.S.A.</xsl:element>
            <xsl:element name="addressline">919-660-5822</xsl:element>
            <xsl:element name="addressline">special-collections@duke.edu</xsl:element>
          </xsl:element>
          <xsl:element name="date">
            <xsl:value-of select="normalize-space(translate(ead:p/ead:date,'©',''))"/>
          </xsl:element>
        </xsl:element>

      </xsl:when>

      <xsl:otherwise>
        <xsl:element name="publicationstmt">
          <xsl:element name="publisher">
            <xsl:value-of select="'David M. Rubenstein Rare Book &amp; Manuscript Library'"/>
          </xsl:element>
          <xsl:element name="address">
            <xsl:element name="addressline">Duke University</xsl:element>
            <xsl:element name="addressline">Durham, NC 27708 U.S.A.</xsl:element>
            <xsl:element name="addressline">919-660-5822</xsl:element>
            <xsl:element name="addressline">special-collections@duke.edu</xsl:element>
          </xsl:element>
          <xsl:element name="date">
            <xsl:value-of select="normalize-space(translate(ead:p/ead:date,'©',''))"/>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Removes all notestmt except for Aleph Number link -->
  <xsl:template match="ead:filedesc/ead:notestmt">
    <xsl:choose>
      <xsl:when test="contains(ead:note/ead:p,'Aleph')">
        <xsl:element name="notestmt">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <!-- Simplify profiledesc -->
  <xsl:template match="ead:profiledesc">
    <xsl:element name="profiledesc">
      <xsl:element name="creation">
        <xsl:value-of select="normalize-space(ead:creation)"/>
        <xsl:element name="date">
          <xsl:value-of select="normalize-space(ead:creation/ead:date)"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="langusage">
        <xsl:value-of select="'English'"/>
      </xsl:element>
      <xsl:element name="descrules">
        <xsl:value-of select="'Describing Archives: A Content Standard'"/>
      </xsl:element>
  </xsl:element>
  </xsl:template>
  
<!-- END EAD Header -->

<!-- Remove <frontmatter>, it's unnecessary and deprecated anyway -->
  <xsl:template match="ead:frontmatter"/>
  

 <!-- ARCHDESC collection-level fixes -->


  <!-- Supplies EADID as <unitid> and writes langmaterial to Generic <note> element with 'Language: ' prefix to preserv prose language statements in AT.  
    This is a hack, but no other way to get prose statements in AT-->
  <xsl:template match="ead:archdesc/ead:did">
    <xsl:element name="did">
      <xsl:apply-templates select="*"/>
      
      <xsl:element name="unitid">
        <xsl:value-of select="//ead:eadid"/>
      </xsl:element>
      
      <xsl:if test="ead:langmaterial">
      <xsl:element name="note"><xsl:attribute name="label">Language of Materials</xsl:attribute><xsl:element name="p">Language: <xsl:value-of select="normalize-space(ead:langmaterial)"/></xsl:element></xsl:element>
      </xsl:if>
    
    </xsl:element>
   </xsl:template>


  <!-- Removes <head> element for <did> -->
  <xsl:template match="ead:archdesc/ead:did/ead:head"/>


  <!-- Standardizes repository terms based on EADID pattern -->
  <xsl:template match="ead:ead/ead:archdesc/ead:did/ead:repository/ead:corpname">
    <xsl:choose>
      <xsl:when test="ancestor::ead:ead/ead:eadheader/ead:eadid[starts-with(.,'adf')]">
        <xsl:element name="corpname">American Dance Festival Archives</xsl:element>
      </xsl:when>
      <xsl:when test="ancestor::ead:ead/ead:eadheader/ead:eadid[starts-with(.,'ua')]">
        <xsl:element name="corpname">Duke University. University Archives</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="corpname">David M. Rubenstein Rare Book &amp; Manuscript Library</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Supply two langmaterial elements, one for natural language, one for normalized with fixes for various invalid marc language codes -->
  <xsl:template match="ead:archdesc/ead:did/ead:langmaterial">
    
    <xsl:element name="langmaterial">
      <xsl:attribute name="label">
        <xsl:value-of select="'Language of Materials'"/>
      </xsl:attribute>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>

    <xsl:element name="langmaterial">
      <xsl:for-each select="ead:language">
        <xsl:element name="language">
          <xsl:attribute name="langcode">

            <xsl:choose>
              
              <xsl:when
                test="./@langcode[.='en']|./@langcode[.='ENG']|./@langcode[.='Eng']|./@langcode[.='enf']|./@langcode[.='English']|./@langcode[.='english']|./@langcode[.='end']|./@langcode[.='engl']|./@langcode[.='ent']|./@langcode[.='eng.']">
                <xsl:value-of select="'eng'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='Spa']|@langcode[.='spn']">
                <xsl:value-of select="'spa'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='fr']">
                <xsl:value-of select="'fre'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='Italian']">
                <xsl:value-of select="'ita'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='Ger']|@langcode[.='de']">
                <xsl:value-of select="'ger'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='jap']">
                <xsl:value-of select="'jpn'"/>
              </xsl:when>

              <xsl:when test="@langcode[.='arb']">
                <xsl:value-of select="'ara'"/>
              </xsl:when>

              <xsl:otherwise>
                <xsl:value-of select="./@langcode"/>
              </xsl:otherwise>

            </xsl:choose>

          </xsl:attribute>

        </xsl:element>

      </xsl:for-each>

    </xsl:element>

  </xsl:template>

  <!-- Remove linebreak from physdesc. Occurs when multiple extent statements present -->
  <xsl:template match="ead:archdesc/ead:did/ead:physdesc/ead:lb"/>
  
<!-- Extent fixes -->
 
<!-- Separate linear foot counts from other extent statements, prefixing others with 'Extent: ' so they map to General Description note instead of extent.  
    Might want to clean this up later in AT -->  

<xsl:template match="ead:archdesc/ead:did/ead:physdesc/ead:extent">
<xsl:choose>
  <xsl:when test="contains(.,'linear') or contains(.,'Linear') or contains(.,'lin.') or contains(.,'Lin.')">
    <xsl:element name="extent">
      <xsl:value-of select="normalize-space(translate(.,'LF','lf'))"/>
    </xsl:element>
  </xsl:when>
  <xsl:otherwise>
    <xsl:element name="extent">
      <xsl:text>Extent: </xsl:text><xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
  
  

  <!-- Consolidate both abstract fields into one. Seems to work. -->
  <xsl:template match="ead:archdesc/ead:did/ead:abstract[1]">
    <xsl:element name="abstract">
      <xsl:value-of select="."/>
      <xsl:if test="following-sibling::*">
        <xsl:text> </xsl:text>
        <xsl:value-of select="following-sibling::*"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- Removes second abstract field after consolidating above -->
  <xsl:template match="ead:archdesc/ead:did/ead:abstract[2]"/>


  <!-- Removes "This finding aid is NCEAD compliant note, WTF does this mean anyway? -->
  <xsl:template match="ead:archdesc/ead:descgrp/ead:processinfo/ead:p">
    <xsl:choose>
      <xsl:when test="contains(.,'NCEAD')"/>
      <xsl:otherwise>
        <xsl:element name="p">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- Streamlines tagging in Related Material section, removing 'content tagging' and date tagging from unittitle -->
  <xsl:template match="//relatedmaterial/archref/unittitle">
  <xsl:value-of select="."/>
  </xsl:template>



  <!--Removes <item> tags from controlaccess terms if present- will not import to AT otherwise.
  Is there any content in controlaccess not in list tags?  Might want to test.
  ALERT!!! SEE cases of mixed tags inside <item> kwileckipaul.xml -->

  <xsl:template match="ead:controlaccess">
    <xsl:choose>
      <xsl:when test="ead:list">
        <xsl:element name="controlaccess">
          <xsl:apply-templates select="ead:head|ead:p|ead:list/ead:item/ead:*"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="controlaccess">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Normalizes space on all controlaccess terms (within <list> or not)-->
  <xsl:template
    match="ead:controlaccess//ead:persname/text()|ead:controlaccess//ead:corpname/text()|ead:controlaccess//ead:geogname/text()|ead:controlaccess//ead:genreform/text()|ead:controlaccess//ead:famname/text()|ead:controlaccess//ead:subject/text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  
  <!-- Removes 'content' tagging from all <p> tags at all levels. -->
 <xsl:template match="ead:archdesc//ead:p/ead:name|ead:archdesc//ead:p/ead:persname|ead:archdesc//ead:p/ead:corpname|ead:archdesc//ead:p/ead:famname|ead:archdesc//ead:p/ead:geogname|ead:archdesc//ead:p/ead:subject|ead:archdesc//ead:p/ead:genreform">
    <xsl:value-of select="."/>
  </xsl:template>



  <!--DATE FIXING STUFF? -->
<!-- Most dates fixed using Oxygen XPATH Regex Find and Replace prior to conversion to EAD schema -->

<!-- Remove all normal date attributes from c02 components and below. Eliminates lots of incorrect machine-created normal dates.  
    DO WE REALLY WANT TO DO THIS?  Any chance we can preserve series-level?-->
<xsl:template match="ead:c02//ead:unitdate/@normal"/>


  <!-- DSC CONTAINER LEVEL STUFF -->
  
<!--Removes unitdate tags from c01 components and below to account for inconsistent normal dates and mixed content
 where some date info is inside unittitle but outside of date
 DO WE REALLY WANT TO DO THIS?  It will be very time consuming to fix component level unitdates and mixed content -->
  
  <xsl:template match="ead:c01//ead:unittitle/ead:unitdate">
	<xsl:value-of select="."/>
</xsl:template>
  
<!-- Removes 'content tagging' from dsc unittitles.  This is unnecessary and inconsistently done in legacy EADs -->
  <xsl:template match="ead:c01//ead:unittitle/ead:name|ead:c01//ead:unittitle/ead:persname|ead:c01//ead:unittitle/ead:famname|ead:c01//ead:unittitle/ead:corpname|ead:c01//ead:unittitle/ead:subject|ead:c01//ead:unittitle/ead:geogname|ead:c01//ead:unittitle/ead:genreform">
    <xsl:value-of select="."/> 
  </xsl:template>  
  
<!-- Removes empty container elements. Borrowed from UVA_as_munger.xsl -->
  <xsl:template match="ead:did/ead:container[normalize-space()='']"/>
  
  
 <!-- Normalizes space on container type attribute and container value --> 
  <xsl:template match="ead:did/ead:container">
    <xsl:element name="container">
      <xsl:attribute name="type"><xsl:value-of select="normalize-space(./@type)"/></xsl:attribute>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  
  
  
  
<!-- Assign container element for every lowest level component based on immediate preceding container assigned (not always a sibling)
Use this logic:
Find all lowest level c0x/did without a container and assign container value and attribute based on immediate preceding container at sibling or ancestor node

<xsl:template match="ead:c02//ead:did[not(ead:container)]">

Assign container to everything matched by this template based on last container value assigned

</xsl:template>

-->  


<!-- Assign level attribute for every component.
    Levels attribute values include Series, Subseries (R), File, Item
        
Use this Logic:
-Lowest level components that have no level, are below a file, and not item = file
-Component below a subseries with no level=file (not always true, but probably safe to assign level)
-

-->


</xsl:stylesheet>
