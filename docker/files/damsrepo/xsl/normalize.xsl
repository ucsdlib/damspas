<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:for-each select="/rdf:RDF/*">
        <xsl:call-template name="copysort"/>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
  <xsl:template name="copysort">
    <xsl:if test="name() != 'dams:event'">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:for-each select="*">
          <!-- sort children by element name, then by rdf subject -->
          <xsl:sort select="concat(name(),*/@rdf:about)"/>
          <xsl:call-template name="copysort"/>
        </xsl:for-each>
        <xsl:for-each select="text()">
          <xsl:if test="normalize-space() != ''">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
