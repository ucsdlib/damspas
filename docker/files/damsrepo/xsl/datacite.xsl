<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns="http://datacite.org/schema/kernel-3"
    exclude-result-prefixes="dams mads rdf">

  <xsl:output method="xml" indent="yes"/>

  <!-- wrapper -->
  <xsl:template match="/rdf:RDF">
    <resource xmlns="http://datacite.org/schema/kernel-3"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd">
      <identifier identifierType="DOI">(:tba)</identifier>

      <xsl:for-each select="dams:AssembledCollection|dams:ProvenanceCollection|dams:ProvenanceCollectionPart">
        <resourceType resourceTypeGeneral="Collection"/>
        <xsl:call-template name="datacite"/>
      </xsl:for-each>

      <xsl:for-each select="dams:Object">
        <xsl:for-each select="dams:typeOfResource[1]">
          <xsl:choose>
            <xsl:when test="text() = 'still image'">
              <resourceType resourceTypeGeneral="Image"/>
            </xsl:when>
            <xsl:when test="text() = 'text'">
              <resourceType resourceTypeGeneral="Text"/>
            </xsl:when>
            <xsl:when test="text() = 'data'">
              <resourceType resourceTypeGeneral="Dataset"/>
            </xsl:when>
            <xsl:when test="text() = 'sound recording'">
              <resourceType resourceTypeGeneral="Sound"/>
            </xsl:when>
            <xsl:when test="text() = 'sound recording-nonmusical'">
              <resourceType resourceTypeGeneral="Sound"/>
            </xsl:when>
            <xsl:when test="text() = 'moving image'">
              <resourceType resourceTypeGeneral="Audiovisual"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>

        <xsl:call-template name="datacite"/>
      </xsl:for-each>

    </resource>
  </xsl:template>

  <!-- core datacite metadata -->
  <xsl:template name="datacite">

    <creators>
      <xsl:for-each select="dams:note/dams:Note[dams:type='preferred citation']/rdf:value">
        <xsl:call-template name="creator">
          <xsl:with-param name="name" select="substring-before(., ' (')"/>
        </xsl:call-template>
      </xsl:for-each>
    </creators>

    <titles>
      <xsl:for-each select="dams:title//mads:authoritativeLabel|dams:title//mads:variantLabel">
        <xsl:variable name="lang">
          <xsl:choose>
            <xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang"/></xsl:when>
            <xsl:otherwise>en-us</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="local-name(../..) = 'hasTranslationVariant'">TranslatedTitle</xsl:when>
            <xsl:when test="local-name(../..) = 'hasVariant'">AlternativeTitle</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="title">
          <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
          <xsl:if test="$type != ''">
            <xsl:attribute name="titleType"><xsl:value-of select="$type"/></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </titles>

    <publisher>UC San Diego Library Digital Collections</publisher>

    <!-- dates -->
    <xsl:for-each select="dams:date/dams:Date[dams:type='issued']">
      <publicationYear><xsl:value-of select="rdf:value"/></publicationYear>
    </xsl:for-each>
    <xsl:if test="dams:date/dams:Date[dams:type != 'published']">
      <dates>
        <xsl:for-each select="dams:date/dams:Date[dams:type != 'published']">
          <xsl:choose>
            <xsl:when test="dams:beginDate != '' and dams:endDate != '' and dams:beginDate != dams:endDate">
              <date>
                <xsl:call-template name="date-type"/>
                <xsl:value-of select="dams:beginDate"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="dams:endDate"/>
              </date>
            </xsl:when>
            <xsl:when test="dams:beginDate != ''">
              <date>
                <xsl:call-template name="date-type"/>
                <xsl:value-of select="dams:beginDate"/>
              </date>
            </xsl:when>
            <xsl:when test="rdf:value != ''">
              <date>
                <xsl:call-template name="date-type"/>
                <xsl:value-of select="rdf:value"/>
              </date>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </dates>
    </xsl:if>

    <alternateIdentifiers>
      <alternateIdentifier alternateIdentifierType="ARK">
        <xsl:value-of select="/rdf:RDF/*/@rdf:about"/>
      </alternateIdentifier>
    </alternateIdentifiers>

    <xsl:if test="dams:note/dams:Note[dams:type='description']">
      <descriptions>
        <xsl:for-each select="dams:note/dams:Note[dams:type='description']">
          <description descriptionType="Abstract">
            <xsl:value-of select="rdf:value"/>
          </description>
        </xsl:for-each>
      </descriptions>
    </xsl:if>

    <!-- subject, excl. geo -->
    <subjects>
      <xsl:for-each select="dams:builtWorkPlace/*|dams:conferenceName/*|dams:corporateName/*|dams:culturalContext/*|dams:familyName/*|dams:function/*|dams:genreForm/*|dams:iconography/*|dams:name/*|dams:occupation/*|dams:otherName/*|dams:personalName/*|dams:scientificName/*|dams:stylePeriod/*|dams:technique/*|dams:temporal/*|dams:topic/*|dams:complexSubject/*">
        <subject>
          <xsl:choose>
            <xsl:when test="mads:isMemberOfMADSScheme/mads:MADSScheme">
              <xsl:for-each select="mads:isMemberOfMADSScheme/mads:MADSScheme">
                <xsl:call-template name="subject-attributes"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="mads:isMemberOfMADSScheme/@rdf:resource">
              <xsl:variable name="sid" select="mads:isMemberOfMADSScheme/@rdf:resource"/>
              <xsl:for-each select="//mads:MADSScheme[@rdf:about=$sid]">
                <xsl:call-template name="subject-attributes"/>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>

          <xsl:value-of select="mads:authoritativeLabel"/>
        </subject>
      </xsl:for-each>
    </subjects>

    <!-- format mime type or filename ext pref. -->
    <formats>
      <xsl:call-template name="format">
        <xsl:with-param name="n">1</xsl:with-param>
      </xsl:call-template>
    </formats>

    <!-- rights -->
    <rightsList>
      <xsl:for-each select="dams:license/dams:License">
        <rights>
          <xsl:if test="dams:licenseURI != ''">
            <xsl:attribute name="rightsURI">
              <xsl:value-of select="dams:licenseURI"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="dams:licenseNote"/>
        </rights>
      </xsl:for-each>
    </rightsList>

    <!-- language -->
    <xsl:if test="dams:language/mads:Language/mads:code != 'zxx'">
      <language>
        <xsl:value-of select="dams:language/mads:Language/mads:code"/>
      </language>
    </xsl:if>

    <!-- geolocation -->
    <xsl:if test="dams:cartographics/dams:Cartographics/dams:point">
      <xsl:for-each select="dams:cartographics/dams:Cartographics/dams:point[1]">
        <xsl:variable name="lat" select="substring-before(., ',')"/>
        <xsl:variable name="rest" select="substring-after(., ',')"/>
        <xsl:variable name="lon">
          <xsl:choose>
            <xsl:when test="contains($rest, ',')">
              <xsl:value-of select="substring-before($rest, ',')"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$rest"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="coords" select="normalize-space(concat($lat,' ',$lon))"/>
        <geoLocations>
          <geoLocation>
            <geoLocationPoint><xsl:value-of select="$coords"/></geoLocationPoint>
          </geoLocation>
        </geoLocations>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  <!-- tokenize creator list on semicolons -->
  <xsl:template name="creator">
    <xsl:param name="name"/>
    <xsl:variable name="before" select="substring-before(concat($name,';'), ';')"/>
    <xsl:variable name="after" select="substring-after($name, '; ')"/>
    <creator>
      <creatorName><xsl:value-of select="$before"/></creatorName>
    </creator>
    <xsl:if test="$after != ''">
      <xsl:call-template name="creator">
        <xsl:with-param name="name" select="$after"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="date-type">
    <xsl:attribute name="dateType">
      <xsl:choose>
        <xsl:when test="dams:type = 'copyright'">Copyrighted</xsl:when>
        <xsl:when test="dams:type = 'collected'">Collected</xsl:when>
        <xsl:when test="dams:type = 'issued'"   >Issued</xsl:when>
        <xsl:otherwise                          >Created</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="subject-attributes">
    <xsl:if test="mads:hasExactExternalAuthority/@rdf:resource != ''">
      <xsl:attribute name="schemeURI">
        <xsl:value-of select="mads:hasExactExternalAuthority/@rdf:resource"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="mads:code != ''">
        <xsl:attribute name="subjectScheme">
          <xsl:value-of select="mads:code"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="rdfs:label != ''">
        <xsl:attribute name="subjectScheme">
          <xsl:value-of select="rdfs:label"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mime-type">
    <xsl:choose>
      <xsl:when test="contains(text(), ';')">
        <xsl:value-of select="substring-before(text(),';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="format">
    <xsl:param name="n"/>
    <xsl:param name="done"/>
    <xsl:variable name="next" select="$n + 1"/>

    <xsl:for-each select="//dams:File[position() = $n]">
      <xsl:variable name="type">
        <xsl:choose>
          <xsl:when test="contains(dams:mimeType,';')">
            <xsl:value-of select="substring-before(dams:mimeType,';')"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="dams:mimeType"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="contains(dams:use,'-service') and not(contains($done,$type))">
        <format><xsl:value-of select="$type"/></format>
      </xsl:if>
      <xsl:variable name="newdone">
        <xsl:value-of select="$done"/>
        <xsl:if test="contains(dams:use,'-service') and not(contains($done,$type))">
          <xsl:value-of select="$type"/>
        </xsl:if>
      </xsl:variable>
      <xsl:if test="//dams:File[position() = $next]">
        <xsl:call-template name="format">
          <xsl:with-param name="n" select="$next"/>
          <xsl:with-param name="done" select="$newdone"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
