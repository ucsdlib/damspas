<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    exclude-result-prefixes="rdf dams mads">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="text()"/>
  <xsl:template match="/">
    <add>
      <xsl:apply-templates/>
    </add>
  </xsl:template>
  <xsl:template match="dams:Object" priority="2">
    <doc>
      <!-- relationship -->
      <xsl:for-each select="dams:relationship">
        <field name="name">
          <xsl:value-of select=".//mads:authoritativeLabel"/>
        </field>
      </xsl:for-each>

      <!-- files -->
      <xsl:for-each select="dams:hasFile/dams:File/@rdf:about">
        <field name="file">
            <xsl:call-template name="chop"/>
        </field>
      </xsl:for-each>

      <!-- license -->
      <!-- statute -->
      <!-- copyright -->
      <xsl:for-each select="dams:copyright/dams:Copyright">
        <field name="copyright_status">
          <xsl:value-of select="dams:copyrightStatus"/>
        </field>
        <field name="copyright_jurisdiction">
          <xsl:value-of select="dams:copyrightJurisdiction"/>
        </field>
        <field name="copyright_note">
          <xsl:value-of select="dams:copyrightNote"/>
        </field>
        <field name="copyright_purpose">
          <xsl:value-of select="dams:copyrightPurposeNote"/>
        </field>
        <field name="copyright_date">
          <xsl:value-of select="dams:date"/>
        </field>
      </xsl:for-each>

      <!-- other rights -->
      <xsl:for-each select="dams:otherRights/dams:OtherRights">
        <field name="other_rights_basis">
          <xsl:value-of select="dams:otherRightsBasis"/>
        </field>
        <field name="other_rights_note">
          <xsl:value-of select="dams:otherRightsNote"/>
        </field>
        <field name="other_rights_uri">
          <xsl:value-of select="dams:otherRightsURI/@rdf:resource"/>
        </field>
        <field name="other_rights_decider">
          <xsl:value-of select="dams:relationship/dams:Relationship[dams:role/dams:Role/rdf:value/text() = 'Decision Maker']/dams:name//mads:authoritativeLabel"/>
        </field>
        <field name="other_rights_permission">
          <xsl:value-of select="dams:permission/dams:Permission"/>
        </field>
        <field name="other_rights_restriction">
          <xsl:value-of select="dams:restriction/dams:Restriction"/>
        </field>
      </xsl:for-each>

      <!-- event ??? -->

      <!-- otherResource -->
      <xsl:for-each select="dams:otherResource/dams:RelatedResource">
        <field name="related_resource">
          <xsl:value-of select="dams:uri"/>
          <xsl:value-of select="dams:type"/>:
          <xsl:value-of select="dams:description"/>
        </field>
      </xsl:for-each>

      <!-- language -->
      <xsl:for-each select="dams:language/@rdf:resource">
        <field name="lang">
          <xsl:call-template name="chop"/>
        </field>
      </xsl:for-each>

      <!-- typeOfResource -->
      <xsl:for-each select="dams:typeOfResource">
        <field name="type">
          <xsl:value-of select="."/>
        </field>
      </xsl:for-each>

      <!-- collection -->
      <xsl:for-each select="dams:collection/dams:Collection">
        <field name="collection">
          <xsl:value-of select="dams:title/rdf:value"/>
        </field>
      </xsl:for-each>

      <!-- organizational unit -->
      <xsl:for-each select="dams:unit/dams:Unit">
        <field name="unit">
          <xsl:value-of select="dams:unitName"/>
        </field>
        <field name="unit_uri">
          <xsl:value-of select="dams:unitURI"/>
        </field>
      </xsl:for-each>

      <!-- title -->
      <xsl:for-each select="dams:title/dams:Title">
        <field name="title">
          <xsl:value-of select="rdf:value"/>
        </field>
        <xsl:if test="dams:relatedTitle/dams:Title">
          <xsl:for-each select="dams:relatedTitle/dams:Title">
            <field name="title_{dams:type}">
              <xsl:value-of select="rdf:value"/>
            </field>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>

      <!-- subject -->
      <xsl:for-each select="dams:subject/mads:ComplexSubject//mads:authoritativeLabel">
        <field name="subject"><xsl:value-of select="."/></field>
      </xsl:for-each>


      <!-- date -->
      <xsl:for-each select="dams:date">
        <xsl:if test="rdf:value">
          <field name="date_display">
            <xsl:value-of select="rdf:value"/>
          </field>
        </xsl:if>
        <xsl:if test="dams:beginDate">
          <field name="date_begin">
            <xsl:value-of select="dams:beginDate"/>
          </field>
        </xsl:if>
        <xsl:if test="dams:endDate">
          <field name="date_end">
            <xsl:value-of select="dams:endDate"/>
          </field>
        </xsl:if>
      </xsl:for-each>

    </doc>
  </xsl:template>

  <xsl:template name="chop">
    <xsl:variable name="idns"
        select="//namespace::node()[local-name()='damsid']"/>
    <xsl:variable name="prns"
        select="//namespace::node()[local-name()='dams']"/>
    <xsl:choose>
      <xsl:when test="starts-with(.,$idns)">
        <xsl:value-of select="substring-after(.,$idns)"/>
      </xsl:when>
      <xsl:when test="starts-with(.,$prns)">
        <xsl:value-of select="substring-after(.,$prns)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
