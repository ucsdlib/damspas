<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="objid"/>
  <xsl:param name="fileid"/>
  <xsl:param name="dsName"/>
  <xsl:param name="objectSize"/>
  <xsl:variable name="dsid">
    <xsl:choose>
      <xsl:when test="$fileid != ''"><xsl:value-of select="translate($fileid,'/','_')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$dsName"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="unknownDate">1999-12-31T23:59:59-0800</xsl:variable>

  <xsl:template match="/">
    <datastreamProfile pid="{$objid}" dsID="{$dsid}"
        xmlns="http://www.fedora.info/definitions/1/0/management/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.fedora.info/definitions/1/0/management/ http://www.fedora.info/definitions/1/0/datastreamProfile.xsd">
      <dsLabel><xsl:value-of select="$fileid"/></dsLabel>
      <dsFormatURI></dsFormatURI>
      <dsControlGroup>X</dsControlGroup>
      <dsVersionable>false</dsVersionable>
      <dsInfoType></dsInfoType>
      <dsLocation><xsl:value-of select="$objid"/>+<xsl:value-of select="$dsid"/></dsLocation>
      <dsLocationType></dsLocationType>
      <dsVersionID><xsl:value-of select="$dsid"/></dsVersionID>
      <dsState>A</dsState>
      <xsl:choose>
        <xsl:when test="$fileid != ''">
          <xsl:for-each select="//dams:File[contains(@rdf:about,$fileid) and substring-after(@rdf:about,$fileid) = ''][1]">
            <xsl:choose>
              <xsl:when test="dams:dateCreated">
                <dsCreateDate><xsl:value-of select="dams:dateCreated"/></dsCreateDate>
              </xsl:when>
              <xsl:otherwise>
                <dsCreateDate><xsl:value-of select="$unknownDate"/></dsCreateDate>
              </xsl:otherwise>
            </xsl:choose>
            <dsMIME><xsl:value-of select="dams:mimeType"/></dsMIME>
            <dsSize><xsl:value-of select="dams:size"/></dsSize>
            <xsl:choose>
              <xsl:when test="dams:sha512checksum">
                <dsChecksumType><xsl:value-of select="dams:sha512checksum"/></dsChecksumType>
                <dsChecksum>SHA-512</dsChecksum>
              </xsl:when>
              <xsl:when test="dams:sha256checksum">
                <dsChecksumType><xsl:value-of select="dams:sha256checksum"/></dsChecksumType>
                <dsChecksum>SHA-256</dsChecksum>
              </xsl:when>
              <xsl:when test="dams:sha1checksum">
                <dsChecksumType><xsl:value-of select="dams:sha1checksum"/></dsChecksumType>
                <dsChecksum>SHA-1</dsChecksum>
              </xsl:when>
              <xsl:when test="dams:md5checksum">
                <dsChecksumType><xsl:value-of select="dams:md5checksum"/></dsChecksumType>
                <dsChecksum>MD5</dsChecksum>
              </xsl:when>
              <xsl:otherwise>
                <dsChecksumType>DISABLED</dsChecksumType>
                <dsChecksum>none</dsChecksum>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <dsMIME>application/rdf+xml</dsMIME>
          <dsSize><xsl:value-of select="$objectSize"/></dsSize>
          <dsChecksumType>DISABLED</dsChecksumType>
          <dsChecksum>none</dsChecksum>
          <xsl:choose>
            <xsl:when test="//dams:Object/dams:event/dams:DAMSEvent[dams:type='record edited']">
              <!-- XXX find latest date if there are multiple modification events -->
              <dsCreateDate><xsl:value-of select="//dams:Object/dams:event/dams:DAMSEvent[dams:type='record edited']/dams:eventDate"/></dsCreateDate>
            </xsl:when>
            <xsl:when test="//dams:Object/dams:event/dams:DAMSEvent[dams:type='record created']">
              <dsCreateDate><xsl:value-of select="//dams:Object/dams:event/dams:DAMSEvent[dams:type='record created']/dams:eventDate"/></dsCreateDate>
            </xsl:when>
            <xsl:when test="//dams:eventDate">
              <dsCreateDate><xsl:value-of select="//dams:eventDate"/></dsCreateDate>
            </xsl:when>
            <xsl:otherwise><dsCreateDate><xsl:value-of select="$unknownDate"/></dsCreateDate></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </datastreamProfile>
  </xsl:template>
</xsl:stylesheet>
