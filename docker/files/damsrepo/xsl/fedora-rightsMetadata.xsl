<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#"
  xmlns="http://hydra-collab.stanford.edu/schemas/rightsMetadata/v1"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="objid"/>
  <xsl:param name="discoverGroup"/>
  <xsl:param name="accessGroup"/>
  <xsl:param name="adminGroup"/>
  <xsl:param name="adminGroup2"/>
  <xsl:param name="superGroup"/>
  <xsl:template match="/">
    <rightsMetadata xsi:schemaLocation="http://hydra-collab.stanford.edu/schemas/rightsMetadata/v1 http://github.com/projecthydra/schemas/tree/v1/rightsMetadata.xsd">
      <copyright>
        <human><xsl:value-of select="//dams:Copyright/dams:copyrightNote"/></human>
        <machine>
          <xsl:for-each select="//dams:License[@rdf:about]">
            <a rel="license" href="{@rdf:about}">
              <xsl:if test="//dams:Permission">
                permission: <xsl:value-of select="//dams:Permission/rdf:value"/>
              </xsl:if>
            </a>
          </xsl:for-each>
          <xsl:for-each select="//dams:Copyright[@rdf:about]">
            <a rel="copyright" href="{@rdf:about}">
              <xsl:value-of select="dams:copyrightStatus"/>
              <xsl:if test="dams:copyrightJurisdiction != ''">
                (<xsl:value-of select="dams:copyrightJurisdiction"/>)
              </xsl:if>
            </a>
          </xsl:for-each>
        </machine>
      </copyright>
      <access type="discover">
        <machine>
          <xsl:if test="$discoverGroup != '' and $discoverGroup != $adminGroup">
            <group><xsl:value-of select="$discoverGroup"/></group>
          </xsl:if>
          <xsl:call-template name="admin-groups"/>
        </machine>
      </access>
      <access type="read">
        <machine>
          <xsl:if test="$accessGroup != '' and $accessGroup != $adminGroup">
            <group><xsl:value-of select="$accessGroup"/></group>
          </xsl:if>
          <xsl:call-template name="admin-groups"/>
        </machine>
      </access>
      <access type="edit">
        <machine>
          <xsl:for-each select="//dams:Unit/dams:unitGroup">
            <xsl:if test="text() != $adminGroup and text() != $adminGroup2">
              <group><xsl:value-of select="."/></group>
            </xsl:if>
          </xsl:for-each>
          <xsl:call-template name="admin-groups"/>
        </machine>
      </access>
<!-- copyrightPurposeNote?
      <use>
        <human>XXX</human>
        <machine>XXX</machine>
      </use>
-->
<!-- if there is an embargo date...
      <embargo>
        <human>XXX</human>
        <machine>
          <date type="release">YYYY-MM-DD</date>
        </machine>
      </embargo>
-->
    </rightsMetadata>

  </xsl:template>
  <xsl:template name="admin-groups">
    <xsl:if test="$adminGroup != ''">
      <group><xsl:value-of select="$adminGroup"/></group>
    </xsl:if>
    <xsl:if test="$adminGroup2 != ''">
      <group><xsl:value-of select="$adminGroup2"/></group>
    </xsl:if>
    <group><xsl:value-of select="$superGroup"/></group>
  </xsl:template>
</xsl:stylesheet>
