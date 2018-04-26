<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:damsid="http://library.ucsd.edu/ark:/20775/">
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:for-each select="/rdf:RDF/*">
        <xsl:variable name="sub" select="@rdf:about"/>
        <xsl:element name="{name()}">
          <xsl:attribute name="rdf:about">
            <xsl:value-of select="$sub"/>
          </xsl:attribute>
          <!-- copy original content -->
          <xsl:for-each select="*">
            <xsl:copy-of select="."/>
          </xsl:for-each>

          <!-- add links to all nested components for hydra -->
          <xsl:for-each select="//dams:Component">
            <xsl:variable name="about" select="@rdf:about"/>
            <xsl:if test="not(//dams:Object/dams:hasComponent/dams:Component[@rdf:about=$about])">
              <dams:hasComponent rdf:resource="{$about}"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
