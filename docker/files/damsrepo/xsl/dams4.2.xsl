<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bf="http://bibframe.org/vocab/"
    xmlns:dams42="http://library.ucsd.edu/ontology/dams42#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
    xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:georss="http://www.georss.org/georss"
    xmlns:ldp="http://www.w3.org/ns/ldp#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:marcrel="http://id.loc.gov/vocabulary/relators/"
    xmlns:mix="http://www.loc.gov/mix/v20#"
    xmlns:modsrdf="http://www.loc.gov/mods/rdf/v1#"
    xmlns:olcruise="http://schema.geolink.org/dev/view#"
    xmlns:pcdm="http://pcdm.org/models#"
    xmlns:pcdmrts="http://pcdm.org/rights#"
    xmlns:premis="http://www.loc.gov/premis/rdf/v1#"
    xmlns:premishash="http://id.loc.gov/vocabulary/preservation/cryptographicHashFunctions/"
    xmlns:r2r="http://linked.rvdata.us/vocab/resource/class/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:vra="http://purl.org/vra/"
    xmlns:wgs84="http://www.w3.org/2003/01/geo/wgs84_pos#">

  <xsl:output method="xml"/>
  <xsl:variable name="oldns">http://library.ucsd.edu/ark:/20775</xsl:variable>
  <xsl:param name="repositoryURL">http://localhost:8080/rest</xsl:param>

  <!-- records ================================================================================ -->
  
  <xsl:template match="/rdf:RDF">
    <rdf:RDF>

      <xsl:apply-templates/>

      <!-- collections -->
      <xsl:for-each select="//dams:AssembledCollection|//dams:ProvenanceCollection|//dams:ProvenanceCollectionPart">
        <xsl:call-template name="collection"/>
      </xsl:for-each>
      <xsl:for-each select="//dams:Unit">
        <xsl:call-template name="unit"/>
      </xsl:for-each>

    </rdf:RDF>
  </xsl:template>

  <!-- object records -->
  <xsl:template match="dams:Object">
    <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
    <dams42:Object rdf:about="{$id}">
      <rdf:type rdf:resource="http://fedora.info/definitions/v4/indexing#indexable"/>
      <rdf:type rdf:resource="http://pcdm.org/models#Object"/>
      <xsl:call-template name="rights-statement"/>
      <xsl:apply-templates/>
    </dams42:Object>
  </xsl:template>

  <!-- components -->
  <xsl:template match="dams:hasComponent">
    <xsl:for-each select="dams:Component">
      <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
      <pcdm:hasMember>
        <dams42:Component rdf:about="{$id}">
          <rdf:type rdf:resource="http://pcdm.org/models#Object"/>
          <xsl:apply-templates/>
        </dams42:Component>
      </pcdm:hasMember>
    </xsl:for-each>
  </xsl:template>

  <!-- collection records -->
  <xsl:template name="collection">
    <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
    <pcdm:Collection rdf:about="{$id}">
      <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/Collection"/>
      <xsl:for-each select="../../@rdf:about">
        <pcdm:hasMember rdf:resource="{.}"/>
      </xsl:for-each>
      <xsl:for-each select="dams:hasAssembledCollection/dams:AssembledCollection/@rdf:about|dams:hasProvenanceCollection/dams:ProvenanceCollection/@rdf:about|dams:hasPart/dams:ProvenanceCollectionPart/@rdf:about|dams:hasAssembledCollection/@rdf:resource|dams:hasProvenanceCollection/@rdf:resource|dams:hasPart/@rdf:resource">
        <pcdm:hasMember rdf:resource="{.}"/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </pcdm:Collection>
  </xsl:template>
  <xsl:template match="dams:hasAssembledCollection|dams:hasProvenanceCollection|dams:hasPart|dams:hasCollection">
    <xsl:for-each select="dams:AssembledCollection|dams:ProvenanceCollection|dams:ProvenanceCollectionPart">
      <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
      <pcdm:memberOf rdf:resource="{$id}"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="unit">
    <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
    <pcdm:AdministrativeSet rdf:about="{$id}">
      <dcterms:title><xsl:value-of select="dams:unitName"/></dcterms:title>
      <dcterms:description><xsl:value-of select="dams:unitDescription"/></dcterms:description>
      <dcterms:relation rdf:resource="{dams:unitURI}"/>
      <xsl:for-each select="//dams:unit">
        <ldp:contains rdf:resource="{../@rdf:about}"/>
      </xsl:for-each>
    </pcdm:AdministrativeSet>
  </xsl:template>

  <xsl:template name="agent">
    <xsl:choose>
      <xsl:when test="mads:authoritativeLabel">
        <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
        <edm:Agent rdf:about="{$id}">
          <skos:prefLabel><xsl:value-of select="mads:authoritativeLabel"/></skos:prefLabel>
          <xsl:for-each select="mads:isMemberOfMADSScheme/mads:MADSScheme/mads:hasExactExternalAuthority[@rdf:resource]">
            <skos:inScheme rdf:resource="{@rdf:resource}"/>
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="local-name() = 'ConferenceName' or local-name() = 'CorporateName'">
              <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization"/>
            </xsl:when>
            <xsl:when test="local-name() = 'PersonalName'">
              <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Person"/>
            </xsl:when>
            <xsl:otherwise>
              <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Group"/>
            </xsl:otherwise>
          </xsl:choose>
        </edm:Agent>
      </xsl:when>
      <xsl:when test="@rdf:about">
        <xsl:attribute name="rdf:resource"><xsl:value-of select="@rdf:about"/></xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- cartographics and geographic => dcterms:spatial -->
  <xsl:template match="dams:cartographics">
    <xsl:for-each select="dams:Cartographics">
      <dcterms:spatial><xsl:call-template name="place"/></dcterms:spatial>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:geographic">
    <xsl:for-each select="mads:Geographic">
      <dcterms:spatial><xsl:call-template name="place"/></dcterms:spatial>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="place">
    <xsl:variable name="newid">
      <xsl:call-template name="newid"/>
    </xsl:variable>
    <edm:Place rdf:about="{$newid}">
      <xsl:for-each select="mads:authoritativeLabel">
        <skos:prefLabel><xsl:value-of select="."/></skos:prefLabel>
      </xsl:for-each>
      <xsl:for-each select="dams:point">
        <wgs84:lat><xsl:value-of select="substring-before(., ',')"/></wgs84:lat>
        <wgs84:long><xsl:value-of select="substring-after(., ',')"/></wgs84:long>
      </xsl:for-each>
      <xsl:for-each select="dams:line">
        <georss:line><xsl:value-of select="."/></georss:line>
      </xsl:for-each>
      <xsl:for-each select="dams:polygon">
        <georss:polygon><xsl:value-of select="."/></georss:polygon>
      </xsl:for-each>
    </edm:Place>
  </xsl:template>

  <!-- collections -->
  <xsl:template match="dams:assembledCollection|dams:provenanceCollection|dams:provenanceCollectionPart">
    <xsl:for-each select="dams:AssembledCollection|dams:ProvenanceCollection|dams:ProvenanceCollectionPart">
      <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
      <pcdm:memberOf rdf:resource="{$id}"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dams:order">
    <!-- TODO ore proxy -->
    <dams42:order><xsl:value-of select="."/></dams42:order>
  </xsl:template>

  <!-- dates -->
  <xsl:template match="dams:date">
    <xsl:for-each select="dams:Date">
      <xsl:choose>
        <xsl:when test="dams:type = 'creation' or dams:type = 'created'">
          <dcterms:created><xsl:call-template name="timespan"/></dcterms:created>
        </xsl:when>
        <xsl:when test="dams:type = 'collected' or dams:type = 'date collected'">
          <dams42:collectionDate><xsl:call-template name="timespan"/></dams42:collectionDate>
        </xsl:when>
        <xsl:when test="dams:type = 'event'">
          <dams42:eventDate><xsl:call-template name="timespan"/></dams42:eventDate>
        </xsl:when>
        <xsl:when test="dams:type = 'copyright'">
          <dcterms:copyright><xsl:call-template name="timespan"/></dcterms:copyright>
        </xsl:when>
        <xsl:when test="dams:type = 'issued' or dams:type = 'date issued'">
          <dcterms:issued><xsl:call-template name="timespan"/></dcterms:issued>
        </xsl:when>
        <xsl:otherwise>
          <dc:date><xsl:call-template name="timespan"/></dc:date>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="timespan">
    <xsl:variable name="newid">
      <xsl:call-template name="newid"/>
    </xsl:variable>
    <edm:TimeSpan rdf:about="{$newid}">
      <xsl:choose>
        <xsl:when test="mads:authoritativeLabel">
          <skos:prefLabel><xsl:value-of select="mads:authoritativeLabel"/></skos:prefLabel>
        </xsl:when>
        <xsl:when test="rdf:value != ''">
          <skos:prefLabel><xsl:value-of select="rdf:value"/></skos:prefLabel>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="dams:beginDate != ''">
        <edm:begin><xsl:value-of select="dams:beginDate"/></edm:begin>
      </xsl:if>
      <xsl:if test="dams:endDate != ''">
        <edm:end><xsl:value-of select="dams:endDate"/></edm:end>
      </xsl:if>
    </edm:TimeSpan>
  </xsl:template>

  <!-- events -->
  <xsl:template match="dams:event"/>
  <!-- TODO events -->

  <!-- files -->
  <xsl:template match="dams:hasFile">
    <xsl:for-each select="dams:File">
      <xsl:sort select="@rdf:about"/>
      <xsl:variable name="fid" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
      <pcdm:hasFile>
        <pcdm:File rdf:about="{$fid}">

          <!-- pcdm file md, see https://wiki.duraspace.org/display/hydra/Technical+Metadata+Application+Profile -->
          <xsl:for-each select="dams:sourceFileName">
            <ebucore:filename><xsl:value-of select="."/></ebucore:filename>
          </xsl:for-each>
          <ebucore:fileSize><xsl:value-of select="dams:size"/></ebucore:fileSize>
          <ebucore:hasMimeType><xsl:value-of select="dams:mimeType"/></ebucore:hasMimeType>
          <ebucore:dateCreated><xsl:value-of select="dams:dateCreated"/></ebucore:dateCreated>
          <xsl:for-each select="dams:crc32checksum">
            <premishash:crc32><xsl:value-of select="."/></premishash:crc32>
          </xsl:for-each>
          <xsl:for-each select="dams:md5checksum">
            <premishash:md5><xsl:value-of select="."/></premishash:md5>
          </xsl:for-each>

          <!-- conflict with fcrepo4 managed predicates:
          <xsl:for-each select="dams:sha1checksum">
            <premishash:sha1><xsl:value-of select="."/></premishash:sha1>
          </xsl:for-each>
          -->

          <!-- premis -->
          <premis:hasFormatName><xsl:value-of select="dams:formatName"/></premis:hasFormatName>
          <xsl:if test="dams:formatVersion">
            <premis:hasFormatVersion><xsl:value-of select="dams:formatVersion"/></premis:hasFormatVersion>
          </xsl:if>
          <premis:hasObjectCategory><xsl:value-of select="dams:objectCategory"/></premis:hasObjectCategory>
          <premis:hasPreservationLevel><xsl:value-of select="dams:preservationLevel"/></premis:hasPreservationLevel>

          <!-- mix -->
          <xsl:for-each select="dams:sourceCapture/dams:SourceCapture">
            <xsl:apply-templates/>
          </xsl:for-each>

          <!-- local properties -->
          <xsl:for-each select="dams:duration">
            <dams42:duration><xsl:value-of select="."/></dams42:duration>
          </xsl:for-each>
          <dams42:quality><xsl:value-of select="dams:quality"/></dams42:quality>
          <xsl:for-each select="dams:sourcePath">
            <dams42:sourcePath><xsl:value-of select="."/></dams42:sourcePath>
          </xsl:for-each>

          <!-- map dams:use to pcdm use vocabulary -->
          <xsl:if test="substring-after(dams:use, '-') = 'alternate'">
            <rdf:type rdf:resource="http://pcdm.org/use#OriginalFile"/>
          </xsl:if>
          <xsl:if test="substring-after(dams:use, '-') = 'icon'">
            <rdf:type rdf:resource="http://pcdm.org/use#ThumbnailImage"/>
          </xsl:if>
          <xsl:if test="substring-after(dams:use, '-') = 'preview'">
            <rdf:type rdf:resource="http://pcdm.org/use#ThumbnailImage"/>
          </xsl:if>
          <xsl:if test="substring-after(dams:use, '-') = 'service'">
            <rdf:type rdf:resource="http://pcdm.org/use#ServiceFile"/>
          </xsl:if>
          <xsl:if test="substring-after(dams:use, '-') = 'source'">
            <rdf:type rdf:resource="http://pcdm.org/use#MasterFile"/>
          </xsl:if>
          <xsl:if test="substring-after(dams:use, '-') = 'thumbnail'">
            <rdf:type rdf:resource="http://pcdm.org/use#ThumbnailImage"/>
          </xsl:if>
        </pcdm:File>
      </pcdm:hasFile>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:sourceType">
    <mix:sourceType><xsl:value-of select="."/></mix:sourceType>
  </xsl:template>
  <xsl:template match="dams:imageProducer">
    <mix:imageProducer><xsl:value-of select="."/></mix:imageProducer>
  </xsl:template>
  <xsl:template match="dams:captureSource">
    <mix:captureSource><xsl:value-of select="."/></mix:captureSource>
  </xsl:template>
  <xsl:template match="dams:scannerManufacturer">
    <mix:scannerManufacturer><xsl:value-of select="."/></mix:scannerManufacturer>
  </xsl:template>
  <xsl:template match="dams:scannerModelName">
    <mix:scannerModelName><xsl:value-of select="."/></mix:scannerModelName>
  </xsl:template>
  <xsl:template match="dams:scanningSoftware">
    <mix:scanningSoftware><xsl:value-of select="."/></mix:scanningSoftware>
  </xsl:template>
  <xsl:template match="dams:scanningSoftwareVersion">
    <mix:scanningSoftwareVersion><xsl:value-of select="."/></mix:scanningSoftwareVersion>
  </xsl:template>

  <!-- language -->
  <xsl:template match="dams:language">
    <xsl:for-each select="mads:Language">
      <xsl:if test="mads:authoritativeLabel or mads:hasExactExternalAuthority">
        <xsl:variable name="newid">
          <xsl:call-template name="newid"/>
        </xsl:variable>
        <dcterms:language>
          <skos:Concept rdf:about="{$newid}">
            <rdf:type rdf:resource="http://purl.org/dc/terms/LinguisticSystem"/>
            <skos:prefLabel><xsl:value-of select="mads:authoritativeLabel"/></skos:prefLabel>
            <xsl:for-each select="mads:isMemberOfMADSScheme/mads:MADSScheme/mads:hasExactExternalAuthority[@rdf:resource]">
              <skos:inScheme rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
            <xsl:for-each select="mads:hasExactExternalAuthority[@rdf:resource]">
              <skos:exactMatch rdf:resource="{@rdf:resource}"/>
            </xsl:for-each>
          </skos:Concept>
        </dcterms:language>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- notes -->
  <xsl:template match="dams:note">
    <xsl:for-each select="dams:Note">
      <xsl:choose>
        <xsl:when test="dams:type = 'identifier'">
          <dcterms:identifier rdf:resource="urn:{translate(dams:displayLabel,' ','-')}:{rdf:value}"/>
        </xsl:when>
        <xsl:when test="dams:type = 'extent'">
          <dcterms:extent><xsl:value-of select="rdf:value"/></dcterms:extent>
        </xsl:when>
        <xsl:when test="dams:type = 'preferred citation'">
          <bf:preferredCitation><xsl:value-of select="rdf:value"/></bf:preferredCitation>
        </xsl:when>
        <xsl:when test="dams:type = 'table of contents'">
          <dcterms:tableOfContents><xsl:value-of select="rdf:value"/></dcterms:tableOfContents>
        </xsl:when>
        <xsl:when test="dams:type = 'arrangement'">
          <bf:materialArrangement><xsl:value-of select="rdf:value"/></bf:materialArrangement>
        </xsl:when>
        <xsl:when test="dams:type = 'biography'">
          <dams42:biography><xsl:value-of select="rdf:value"/></dams42:biography>
        </xsl:when>
        <xsl:when test="dams:type = 'credits'">
          <bf:creditsNote><xsl:value-of select="rdf:value"/></bf:creditsNote>
        </xsl:when>
        <xsl:when test="dams:type = 'custodial history'">
          <bf:custodialHistory><xsl:value-of select="rdf:value"/></bf:custodialHistory>
        </xsl:when>
        <xsl:when test="dams:type = 'description'">
          <dcterms:abstract><xsl:value-of select="rdf:value"/></dcterms:abstract>
          <!-- general note ??? -->
        </xsl:when>
        <xsl:when test="dams:type = 'edition'">
          <bf:edition><xsl:value-of select="rdf:value"/></bf:edition>
        </xsl:when>
        <xsl:when test="dams:type = 'inscription'">
          <dams42:inscription><xsl:value-of select="rdf:value"/></dams42:inscription>
        </xsl:when>
        <xsl:when test="dams:type = 'local attribution'">
          <dams42:localAttribution><xsl:value-of select="rdf:value"/></dams42:localAttribution>
        </xsl:when>
        <xsl:when test="dams:type = 'location of originals'">
          <dams42:locationOfOriginals><xsl:value-of select="rdf:value"/></dams42:locationOfOriginals>
        </xsl:when>
        <xsl:when test="dams:type = 'material details'">
          <xsl:choose>
            <xsl:when test="dams:displaLabel = 'finds'">
              <dams42:finds><xsl:value-of select="rdf:value"/></dams42:finds>
            </xsl:when>
            <xsl:when test="dams:displaLabel = 'limits'">
              <dams42:limits><xsl:value-of select="rdf:value"/></dams42:limits>
            </xsl:when>
            <xsl:when test="dams:displaLabel = 'relationship to other loci'">
              <dams42:relationshipToOtherLoci><xsl:value-of select="rdf:value"/></dams42:relationshipToOtherLoci>
            </xsl:when>
            <xsl:when test="dams:displaLabel = 'storage method'">
              <dams42:storageMethod><xsl:value-of select="rdf:value"/></dams42:storageMethod>
            </xsl:when>
            <xsl:when test="dams:displaLabel = 'water depth'">
              <dams42:waterDepth><xsl:value-of select="rdf:value"/></dams42:waterDepth>
            </xsl:when>
            <xsl:otherwise>
              <dams42:materialDetails><xsl:value-of select="rdf:value"/></dams42:materialDetails>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="dams:type = 'performers'">
          <bf:performerNote><xsl:value-of select="rdf:value"/></bf:performerNote>
        </xsl:when>
        <xsl:when test="dams:type = 'physical description'">
          <dams42:physicalDescription><xsl:value-of select="rdf:value"/></dams42:physicalDescription>
        </xsl:when>
        <xsl:when test="dams:type = 'publication'">
          <dams42:publication><xsl:value-of select="rdf:value"/></dams42:publication>
        </xsl:when>
        <xsl:when test="dams:type = 'scope and content'">
          <bf:contentsNote><xsl:value-of select="rdf:value"/></bf:contentsNote>
        </xsl:when>
        <xsl:when test="dams:type = 'series'">
          <bf:series>
            <pcdm:Collection rdf:about="#{generate-id()}">
              <dcterms:title><xsl:value-of select="rdf:value"/></dcterms:title>
            </pcdm:Collection>
          </bf:series>
        </xsl:when>
        <xsl:when test="dams:type = 'statement of responsibility'">
          <bf:responsibilityStatement><xsl:value-of select="rdf:value"/></bf:responsibilityStatement>
        </xsl:when>
        <xsl:when test="dams:type = 'technical requirements'">
          <dams42:techincalDetails><xsl:value-of select="rdf:value"/></dams42:techincalDetails>
        </xsl:when>
        <xsl:when test="dams:type = 'venue'">
          <!-- XXX Q: dams42:venue or dams42:site? -->
          <dams42:venue><xsl:value-of select="rdf:value"/></dams42:venue>
        </xsl:when>
        <xsl:otherwise>
          <dcterms:description><xsl:value-of select="rdf:value"/></dcterms:description>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:custodialResponsibilityNote">
    <bf:responsibilityStatement>
      <xsl:value-of select="dams:CustodialResponsibilityNote/rdf:value"/>
    </bf:responsibilityStatement>
  </xsl:template>
  <xsl:template match="dams:preferredCitationNote">
    <bf:preferredCitation>
      <xsl:value-of select="dams:PreferredCitationNote/rdf:value"/>
    </bf:preferredCitation>
  </xsl:template>
  <xsl:template match="dams:scopeContentNote">
    <dams42:briefDescription>
      <xsl:value-of select="dams:ScopeContentNote/rdf:value"/>
    </dams42:briefDescription>
  </xsl:template>

  <!-- related resources -->
  <xsl:template match="dams:relatedCollection">
    <dcterms:relation rdf:resource="{@rdf:resource}"/>
  </xsl:template>
  <xsl:template match="dams:relatedResource">
    <xsl:for-each select="dams:RelatedResource">
      <xsl:choose>
        <xsl:when test="@rdf:about">
          <xsl:variable name="tmp" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
          <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>

          <xsl:choose>
            <xsl:when test="dams:type='area'"><dams42:area rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='depiction'"><dams42:depiction rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='online exhibit'"><dams42:exhibit rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='online finding aid'"><dams42:findingAid rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='locus'"><dams42:locus rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='news release'"><dams42:newsRelease rdf:resource="{$id}"/></xsl:when>
            <xsl:when test="dams:type='stratum'"><dams42:stratum rdf:resource="{$id}"/></xsl:when>
            <xsl:otherwise><dcterms:relation rdf:resource="{$id}"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- TODO directly attach thumbnail, or link to URL? -->
          <dams42:thumbnail rdf:resource="{dams:uri/@rdf:resource|dams:uri/text()}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- relationships -->
  <xsl:template match="dams:relationship">
    <xsl:for-each select="dams:Relationship">
      <xsl:variable name="roleid" select="dams:role/@rdf:resource"/>

      <xsl:variable name="code">
        <xsl:choose>
          <!-- name display label mappings -->
          <xsl:when test="dams:corporateName/mads:CorporateName/dams:displayLabel = 'cruise'">
            <xsl:text>hasCruise</xsl:text>
          </xsl:when>
          <xsl:when test="dams:corporateName/mads:CorporateName/dams:displayLabel = 'ship'">
            <xsl:text>VesselName</xsl:text>
          </xsl:when>

          <!-- role code/label mappings (transformations) -->
          <xsl:when test="dams:role/mads:Authority/mads:code='ctb' or
                          dams:role/mads:Authority/mads:authoritativeLabel='contributor'">
             <xsl:text>contributor</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:code='cpi' or
                          dams:role/mads:Authority/mads:authoritativeLabel='co-principal investigator'">
            <xsl:text>coPrincipalInvestigator</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:code='cre' or
                          dams:role/mads:Authority/mads:authoritativeLabel='creator'">
             <xsl:text>creator</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:authoritativeLabel='donor'">
            <xsl:text>dnr</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:authoritativeLabel='field assistant'">
            <xsl:text>fieldAssistant</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:authoritativeLabel='laboratory assistant'">
            <xsl:text>laboratoryAssistant</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:code='pri' or
                          dams:role/mads:Authority/mads:authoritativeLabel='principal investigator'">
            <xsl:text>principalInvestigator</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:authoritativeLabel='producer'">
            <xsl:text>pro</xsl:text>
          </xsl:when>
          <xsl:when test="dams:role/mads:Authority/mads:authoritativeLabel='vessel'">
            <xsl:text>VesselName</xsl:text>
          </xsl:when>

          <!-- role code mappings (direct mapping) -->
          <xsl:when test="dams:role/mads:Authority/mads:code">
            <xsl:value-of select="dams:role/mads:Authority/mads:code"/>
          </xsl:when>
          <xsl:when test="//mads:Authority[@rdf:about=$roleid]/mads:code">
            <xsl:value-of select="//mads:Authority[@rdf:about=$roleid]/mads:code"/>
          </xsl:when>

          <!-- if all else fails, use generic creator role -->
          <xsl:otherwise>creator</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ns">
        <xsl:choose>
          <xsl:when test="$code = 'creator' or $code = 'contributor'">dcterms</xsl:when>
          <xsl:when test="$code = 'coPrincipalInvestigator' or $code = 'fieldAssistant'
                       or $code = 'laboratoryAssistant' or $code = 'principalInvestigator'">
            <xsl:text>dams42</xsl:text>
          </xsl:when>
          <xsl:when test="$code = 'hasCruise'">olcruise</xsl:when>
          <xsl:when test="$code = 'VesselName'">r2r</xsl:when>
          <xsl:otherwise>marcrel</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:element name="{$ns}:{$code}">
        <xsl:for-each select="dams:personalName/mads:PersonalName|dams:corporateName/mads:CorporateName|dams:conferenceName/mads:ConferenceName|dams:familyName/mads:FamilyName|dams:otherName/mads:Name|dams:name/mads:Name">
          <xsl:call-template name="agent"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <!-- rights -->
  <xsl:template match="dams:copyright">
    <xsl:for-each select="dams:Copyright">
      <xsl:for-each select="dams:copyrightJurisdiction">
        <premis:hasCopyrightJurisdiction><xsl:value-of select="."/></premis:hasCopyrightJurisdiction>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="dams:copyrightStatus = 'Under copyright'">
          <premis:hasCopyrightStatus rdf:resource="http://id.loc.gov/vocabulary/preservation/copyrightStatus/cpr"/>
        </xsl:when>
        <xsl:when test="dams:copyrightStatus = 'Public domain'">
          <premis:hasCopyrightStatus rdf:resource="http://id.loc.gov/vocabulary/preservation/copyrightStatus/pub"/>
        </xsl:when>
        <xsl:otherwise>
          <premis:hasCopyrightStatus rdf:resource="http://id.loc.gov/vocabulary/preservation/copyrightStatus/unk"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:license">
    <xsl:for-each select="dams:License">
      <xsl:choose>
        <xsl:when test="@rdf:about">
          <xsl:variable name="id" select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
          <premis:hasLicenseTerms rdf:resource="{$id}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="dams:licenseNote">
            <premis:hasLicenseTerms><xsl:value-of select="."/></premis:hasLicenseTerms>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:otherRights">
    <xsl:for-each select="dams:OtherRights/dams:otherRightsBasis">
      <dams42:otherRights><xsl:value-of select="."/></dams42:otherRights>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:rightsHolder|dams:rightsHolderName|dams:rightsHolderCorporate|dams:rightsHolderPersonal">
    <xsl:for-each select="*">
      <dcterms:rightsHolder><xsl:call-template name="agent"/></dcterms:rightsHolder>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:statute">
    <!-- we don't actually have this... -->
  </xsl:template>

  <!-- suppress from main body (see rights statement) -->
  <xsl:template match="dams:visibility"/>

  <!-- new hydra-plus rights statement -->
  <xsl:template name="rights-statement">
    <xsl:variable name="rightsHolder">
      <xsl:choose>
        <xsl:when test="dams:rightsHolderCorporate/mads:CorporateName">
           <xsl:value-of select="dams:rightsHolderCorporate/mads:CorporateName/mads:authoritativeLabel"/>
        </xsl:when>
        <xsl:when test="dams:rightsHolderPersonal/mads:PersonalName">
           <xsl:value-of select="dams:rightsHolderPersonal/mads:PersonalName/mads:authoritativeLabel"/>
        </xsl:when>
        <xsl:when test="dams:rightsHolderName/mads:Name">
           <xsl:value-of select="dams:rightsHolderName/mads:Name/mads:authoritativeLabel"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- base rights -->
    <xsl:choose>
      <xsl:when test="dams:copyright/dams:Copyright/dams:copyrightStatus = 'Public domain'">
        <edm:rights rdf:resource="http://creativecommons.org/publicdomain/mark/1.0/"/>
      </xsl:when>
      <xsl:when test="contains(dams:license/dams:License/dams:licenseURI, 'creativecommons.org')">
        <edm:rights rdf:resource="{dams:license/dams:License/dams:licenseURI}"/>
      </xsl:when>
      <xsl:when test="dams:copyright/dams:Copyright/dams:copyrightStatus = 'Under copyright' and $rightsHolder = 'UC Regents'">
        <edm:rights rdf:resource="http://www.europeana.eu/rights/rr-f/"/>
      </xsl:when>
      <xsl:otherwise>
        <edm:rights rdf:resource="http://library.ucsd.edu/ontology/dams4.2access#private"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- overrides -->
    <xsl:choose>
      <xsl:when test="dams:assembledCollection/dams:AssembledCollection/dams:visibility = 'curator'
                   or dams:provenanceCollection/dams:ProvenanceCollection/dams:visibility = 'curator'
                   or dams:provenanceCollectionPart/dams:ProvenanceCollectionPart/dams:visibility = 'curator'
                   or dams:visibility = 'curator'">
        <pcdmrts:rightsOverride rdf:resource="http://library.ucsd.edu/ontology/dams4.2access#private"/>
      </xsl:when>
      <xsl:when test="dams:visibility = 'local'">
        <pcdmrts:rightsOverride rdf:resource="http://library.ucsd.edu/ontology/dams4.2access#campus"/>
      </xsl:when>
      <xsl:when test="dams:visibility = 'public'">
        <pcdmrts:rightsOverride rdf:resource="http://www.europeana.eu/rights/rr-f/"/>
      </xsl:when>
      <xsl:when test="//dams:Restriction[dams:type='display']">
        <pcdmrts:rightsOverride rdf:resource="http://library.ucsd.edu/ontology/dams4.2access#private"/>
      </xsl:when>
      <xsl:when test="//dams:Permission[dams:type='display']">
        <pcdmrts:rightsOverride rdf:resource="http://www.europeana.eu/rights/rr-f/"/>
      </xsl:when>
      <xsl:when test="//dams:Permission[dams:type='local']">
        <pcdmrts:rightsOverride rdf:resource="http://library.ucsd.edu/ontology/dams4.2access#campus"/>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="//dams:Restriction/dams:endDate">
        <pcdmrts:rightsOverrideExpiration>
          <xsl:value-of select="//dams:Restriction/dams:endDate"/>
        </pcdmrts:rightsOverrideExpiration>
      </xsl:when>
      <xsl:when test="//dams:Permission/dams:endDate">
        <pcdmrts:rightsOverrideExpiration>
          <xsl:value-of select="//dams:Permission/dams:endDate"/>
        </pcdmrts:rightsOverrideExpiration>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- subjects -->
  <xsl:template name="subject">
    <xsl:choose>
      <xsl:when test="mads:authoritativeLabel">
        <xsl:variable name="newid">
          <xsl:call-template name="newid"/>
        </xsl:variable>
        <skos:Concept rdf:about="{$newid}">
          <skos:prefLabel><xsl:value-of select="mads:authoritativeLabel"/></skos:prefLabel>
          <xsl:for-each select="mads:isMemberOfMADSScheme/mads:MADSScheme">
            <xsl:choose>
              <xsl:when test="mads:hasExactExternalAuthority/@rdf:resource">
                <skos:inScheme rdf:resource="{mads:hasExactExternalAuthority/@rdf:resource}"/>
              </xsl:when>
              <xsl:when test="@rdf:about">
                <skos:inScheme>
                  <skos:ConceptScheme rdf:about="{@rdf:about}">
                    <dcterms:title><xsl:value-of select="rdfs:label"/></dcterms:title>
                  </skos:ConceptScheme>
                </skos:inScheme>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </skos:Concept>
      </xsl:when>
      <xsl:when test="@rdf:about">
        <xsl:attribute name="rdf:resource"><xsl:value-of select="@rdf:about"/></xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="dams:complexSubject">
    <xsl:for-each select="mads:ComplexSubject">
      <xsl:variable name="newid">
        <xsl:call-template name="newid"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="count(mads:componentList/*) = 1">
          <!-- if there's only one component, skip the complex subject wrapper -->
          <xsl:call-template name="complexSubjectComponents"/>
        </xsl:when>
        <xsl:when test="mads:authoritativeLabel">
          <dams42:complexSubject>
            <dams42:ComplexSubject rdf:about="{$newid}">
              <skos:prefLabel><xsl:value-of select="mads:authoritativeLabel"/></skos:prefLabel>
              <xsl:for-each select="mads:isMemberOfMADSScheme/mads:MADSScheme/mads:hasExactExternalAuthority[@rdf:resource]">
                <skos:inScheme rdf:resource="{@rdf:resource}"/>
              </xsl:for-each>
              <xsl:call-template name="complexSubjectComponents"/>
            </dams42:ComplexSubject>
          </dams42:complexSubject>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="complexSubjectComponents">
    <xsl:for-each select="mads:componentList/*">
      <xsl:choose>
        <xsl:when test="local-name() = 'CommonName'">
          <dwc:vernacularName><xsl:call-template name="subject"/></dwc:vernacularName>
        </xsl:when>
        <xsl:when test="local-name() = 'CulturalContext'">
          <vra:culturalContext><xsl:call-template name="subject"/></vra:culturalContext>
        </xsl:when>
        <xsl:when test="local-name() = 'GenreForm'">
          <bf:genre><xsl:call-template name="subject"/></bf:genre>
        </xsl:when>
        <xsl:when test="local-name() = 'ScientificName'">
          <dwc:scientificName><xsl:call-template name="subject"/></dwc:scientificName>
        </xsl:when>
        <xsl:when test="local-name() = 'Temporal'">
          <dc:temporal><xsl:call-template name="subject"/></dc:temporal>
        </xsl:when>
        <xsl:when test="local-name() = 'Topic'">
          <dc:subject><xsl:call-template name="subject"/></dc:subject>
        </xsl:when>
  
        <xsl:when test="local-name() = 'ConferenceName' or local-name() = 'CorporateName'
                     or local-name() = 'FamilyName' or local-name() = 'Name' or local-name() = 'PersonalName'">
          <dams42:name><xsl:call-template name="agent"/></dams42:name>
        </xsl:when>
        <xsl:when test="local-name() = 'Geographic'">
          <dcterms:spatial><xsl:call-template name="place"/></dcterms:spatial>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:commonName">
    <xsl:for-each select="dams:CommonName">
      <dwc:vernacularName><xsl:call-template name="subject"/></dwc:vernacularName>
     </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:culturalContext">
    <xsl:for-each select="dams:CulturalContext">
      <vra:culturalContext><xsl:call-template name="subject"/></vra:culturalContext>
     </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:genreForm">
    <xsl:for-each select="mads:GenreForm">
      <bf:genre><xsl:call-template name="subject"/></bf:genre>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:scientificName">
    <xsl:for-each select="dams:ScientificName">
      <dwc:scientificName><xsl:call-template name="subject"/></dwc:scientificName>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:temporal">
    <xsl:for-each select="mads:Temporal">
      <dc:temporal><xsl:call-template name="timespan"/></dc:temporal>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:topic">
    <xsl:for-each select="mads:Topic">
      <xsl:choose>
        <xsl:when test="mads:isMemberOfMADSScheme/mads:MADSScheme/@rdf:about = 'http://library.ucsd.edu/ark:/20775/bb1332366f' or mads:isMemberOfMADSScheme/mads:MADSScheme/@rdf:about = 'http://library.ucsd.edu/ark:/20775/bb2595178k'">
          <dwc:lithostratigraphicTerms><xsl:call-template name="subject"/></dwc:lithostratigraphicTerms>
        </xsl:when>
        <xsl:otherwise>
          <dc:subject><xsl:call-template name="subject"/></dc:subject>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="dams:conferenceName|dams:corporateName|dams:familyName|dams:otherName|dams:personalName">
    <xsl:for-each select="mads:ConferenceName|mads:CorporateName|mads:FamilyName|mads:Name|mads:PersonalName">
      <dams42:name><xsl:call-template name="agent"/></dams42:name>
    </xsl:for-each>
  </xsl:template>

  <!-- titles -->
  <xsl:template match="dams:title">
    <xsl:for-each select="mads:Title">
      <xsl:for-each select="mads:elementList/mads:MainTitleElement">
        <dcterms:title><xsl:value-of select="mads:elementValue"/></dcterms:title>
      </xsl:for-each>
      <xsl:for-each select="mads:elementList/mads:SubTitleElement">
        <modsrdf:subTitle><xsl:value-of select="mads:elementValue"/></modsrdf:subTitle>
      </xsl:for-each>
      <xsl:for-each select="mads:elementList/mads:PartNameElement">
        <modsrdf:partName><xsl:value-of select="mads:elementValue"/></modsrdf:partName>
      </xsl:for-each>
      <xsl:for-each select="mads:elementList/mads:PartNumberElement">
        <modsrdf:partNumber><xsl:value-of select="mads:elementValue"/></modsrdf:partNumber>
      </xsl:for-each>
      <xsl:for-each select="mads:hasVariant/mads:Variant|mads:hasTranslationVariant/mads:Variant">
        <dcterms:alternative><xsl:value-of select="mads:variantLabel"/></dcterms:alternative>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <!-- type of resource -->
  <xsl:template match="dams:typeOfResource">
    <xsl:choose>
      <xsl:when test="text() = 'image' or text() = 'still image'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>
      </xsl:when>
      <xsl:when test="text() = 'text'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
      </xsl:when>
      <xsl:when test="text() = 'data'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/Dataset"/>
      </xsl:when>
      <xsl:when test="text() = 'sound recording'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/Sound"/>
      </xsl:when>
      <xsl:when test="text() = 'sound recording-nonmusical'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/Sound"/>
      </xsl:when>
      <xsl:when test="text() = 'video' or text() = 'moving image'">
        <dcterms:type rdf:resource="http://purl.org/dc/dcmitype/MovingImage"/>
      </xsl:when>
    </xsl:choose>
<!--
DCMIType vocab:
	http://purl.org/dc/dcmitype/Collection
	http://purl.org/dc/dcmitype/Dataset
	http://purl.org/dc/dcmitype/Event
	http://purl.org/dc/dcmitype/Image
	http://purl.org/dc/dcmitype/InteractiveResource
	http://purl.org/dc/dcmitype/MovingImage
	http://purl.org/dc/dcmitype/PhysicalObject
	http://purl.org/dc/dcmitype/Service
	http://purl.org/dc/dcmitype/Software
	http://purl.org/dc/dcmitype/Sound
	http://purl.org/dc/dcmitype/StillImage
	http://purl.org/dc/dcmitype/Text

TODO Unmapped values:
	Cartographic - can just skip because these also have image or text
	Mixed material - these should be updated with the individual types
-->
  </xsl:template>

  <!-- find the current identifier, or generate a hashURI identifier -->
  <xsl:template name="newid">
    <xsl:choose>
      <xsl:when test="../@rdf:resource != ''">
        <xsl:value-of select="concat($repositoryURL, substring-after(@rdf:resource, $oldns))"/>
      </xsl:when>
      <xsl:when test="@rdf:about != ''">
        <xsl:value-of select="concat($repositoryURL, substring-after(@rdf:about, $oldns))"/>
      </xsl:when>
      <xsl:otherwise>#<xsl:value-of select="generate-id()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- suppress link from object to unit/adminset -->
  <xsl:template match="dams:unit"/>

  <!-- suppress events -->
  <xsl:template match="rdf:Description[dams:event/dams:DAMSEvent/dams:type='record deleted']"/>

  <!-- clearly mark unhandled elements -->
  <xsl:template match="*">
    <XXX><xsl:value-of select="name()"/></XXX>
  </xsl:template>

</xsl:stylesheet>
