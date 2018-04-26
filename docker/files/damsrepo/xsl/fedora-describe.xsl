<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <fedoraRepository
      xmlns="http://www.fedora.info/definitions/1/0/access/"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.fedora.info/definitions/1/0/access/ http://www.fedora.info/definitions/1/0/fedoraRepository.xsd">
      <repositoryName>DAMS Repository (Fedora Compatability)</repositoryName>
      <repositoryBaseURL>
        <xsl:value-of select="/response/baseURL"/>
        <xsl:text>/fedora</xsl:text>
      </repositoryBaseURL>
      <repositoryVersion>
        <xsl:value-of select="/response/fedoraCompat"/>
      </repositoryVersion>
      <repositoryPID>
        <PID-namespaceIdentifier></PID-namespaceIdentifier>
        <PID-delimiter></PID-delimiter>
        <PID-sample>
          <xsl:value-of select="/response/sampleObject"/>
        </PID-sample>
        <retainPID>*</retainPID>
      </repositoryPID>
      <repositoryOAI-identifier>
        <OAI-namespaceIdentifier>example.org</OAI-namespaceIdentifier>
        <OAI-delimiter>:</OAI-delimiter>
        <OAI-sample>oai:example.org:changeme:100</OAI-sample>
      </repositoryOAI-identifier>
      <sampleSearch-URL>
        <xsl:value-of select="/response/baseURL"/>
        <xsl:text>/fedora/objects</xsl:text>
      </sampleSearch-URL>
      <sampleAccess-URL>
        <xsl:value-of select="/response/baseURL"/>
        <xsl:text>/fedora/objects/</xsl:text>
        <xsl:value-of select="/response/sampleObject"/>
      </sampleAccess-URL>
      <sampleOAI-URL>
        <xsl:value-of select="/response/baseURL"/>
        <xsl:text>/fedora/oai?verb=Identify</xsl:text>
      </sampleOAI-URL>
      <adminEmail>
        <xsl:value-of select="/response/adminEmail"/>
      </adminEmail>
    </fedoraRepository>
  </xsl:template>
</xsl:stylesheet>
