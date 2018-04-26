<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <pidList xmlns="http://www.fedora.info/definitions/1/0/management/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.fedora.info/definitions/1/0/management/ http://www.fedora.info/definitions/1/0/getNextPIDInfo.xsd">
      <xsl:for-each select="/response/ids/value">
        <pid><xsl:value-of select="."/></pid>
      </xsl:for-each>
    </pidList>
  </xsl:template>
</xsl:stylesheet>
