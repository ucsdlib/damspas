<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <xsl:output method="text"/>
  <xsl:param name="objid"/>
  <xsl:param name="fileid"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$fileid != ''">
        <xsl:for-each select="//dams:File[contains(@rdf:about,concat('/',$fileid))]">
          <xsl:value-of select="dams:dateCreated"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="//dams:Object/dams:event/dams:Event[dams:type='record edited']">
        <!-- XXX find latest date if there are multiple modification events -->
        <xsl:value-of select="//dams:Object/dams:event/dams:Event[dams:type='record edited']/dams:eventDate"/>
      </xsl:when>
      <xsl:when test="//dams:Object/dams:event/dams:Event[dams:type='record created']">
        <xsl:value-of select="//dams:Object/dams:event/dams:Event[dams:type='record created']/dams:eventDate"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1999-12-31T23:59:59-0800</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
