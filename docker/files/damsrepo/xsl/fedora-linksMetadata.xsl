<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:ns0="info:fedora/fedora-system:def/model#"
    xmlns:ns1="info:fedora/fedora-system:def/relations-external#dams:"
    exclude-result-prefixes="dams">
  <xsl:param name="objid"/>
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <xsl:text>
</xsl:text>
    <rdf:RDF>
      <rdf:Description rdf:about="info:fedora/{$objid}">
        <xsl:choose>
          <xsl:when test="//*[contains(@rdf:about,$objid)]/dams:relatedResource/dams:RelatedResource[dams:type='hydra-afmodel']">
            <ns0:hasModel rdf:resource="{//dams:RelatedResource[dams:type='hydra-afmodel']/dams:uri}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="//*[contains(@rdf:about,$objid)]">
              <xsl:if test="position() = 1">
                <xsl:variable name="prefix">
                  <xsl:choose>
                    <xsl:when test="namespace-uri() = 'http://www.loc.gov/mads/rdf/v1#'">
                      <xsl:text>Mads</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>Dams</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="suffix">
                  <xsl:choose>
                    <xsl:when test="starts-with(local-name(),'MADS') or starts-with(local-name(),'DAMS')">
                      <xsl:value-of select="substring(local-name(),5)"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <ns0:hasModel rdf:resource="info:fedora/afmodel:{$prefix}{$suffix}"></ns0:hasModel>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="//dams:vocabulary">
          <xsl:variable name="vid" select="substring-after(@rdf:resource,'http://library.ucsd.edu/ark:/20775/')"/>
          <ns1:vocabulary rdf:resource="info:fedora/{$vid}"></ns1:vocabulary>
        </xsl:for-each>
      </rdf:Description>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
