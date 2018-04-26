<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="objid"/>
  <xsl:template match="/">

    <xsl:variable name="type">
      <xsl:value-of select="local-name(/rdf:RDF/*)"/>
    </xsl:variable>

    <!-- XXX find latest date if there are multiple modification events -->
    <xsl:variable name="timestamp">
      <xsl:choose>
        <xsl:when test="//dams:DAMSEvent[contains(dams:type,'modification')]">
          <xsl:value-of select="//dams:DAMSEvent[contains(dams:type,'modification')]/dams:eventDate"/>
        </xsl:when>
        <xsl:when test="//dams:DAMSEvent[contains(dams:type,'creation')]">
          <xsl:value-of select="//dams:DAMSEvent[contains(dams:type,'creation')]/dams:eventDate"/>
        </xsl:when>
        <xsl:when test="//dams:DAMSEvent/dams:eventDate">
          <xsl:value-of select="//dams:DAMSEvent/dams:eventDate"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>1999-12-31T23:59:59-0800</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- XXX add to data model? -->
    <xsl:variable name="owner">foo</xsl:variable>

    <!-- XXX use title? is this used for anything? -->
    <xsl:variable name="label"></xsl:variable>

    <!-- XXX pass from parameter? is this used for anything? -->
    <xsl:variable name="baseURL">http://localhost:8080</xsl:variable>

    <objectProfile xmlns="http://www.fedora.info/definitions/1/0/access/"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.fedora.info/definitions/1/0/access/ http://www.fedora.info/definitions/1/0/objectProfile.xsd"
      pid="{$objid}">
      <objLabel><xsl:value-of select="$label"/></objLabel>
      <objOwnerId><xsl:value-of select="$owner"/></objOwnerId>
      <objModels>
        <model>info:fedora/afmodel:<xsl:value-of select="$type"/></model>
        <model>info:fedora/fedora-system:FedoraObject-3.0</model>
      </objModels>
      <objCreateDate><xsl:value-of select="$timestamp"/></objCreateDate>
      <objLastModDate><xsl:value-of select="$timestamp"/></objLastModDate>
      <objDissIndexViewURL><xsl:value-of select="$baseURL"/>/dams/fedora/objects/<xsl:value-of select="$objid"/>/methods/fedora-system%3A3/viewMethodIndex</objDissIndexViewURL>
      <objItemIndexViewURL><xsl:value-of select="$baseURL"/>/dams/fedora/objects/<xsl:value-of select="$objid"/>/methods/fedora-system%3A3/viewItemIndex</objItemIndexViewURL>
      <objState>A</objState>
    </objectProfile>
  </xsl:template>
</xsl:stylesheet>
