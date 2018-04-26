<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
      xmlns:dams="http://library.ucsd.edu/ontology/dams#"
      xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
      xmlns:owl="http://www.w3.org/2002/07/owl#"
      xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	  exclude-result-prefixes="dams mads owl rdf rdfs">
  <xsl:output method="html" encoding="utf-8" version="4.0"/>
  	<xsl:param name="baseurl"/>
  	<xsl:param name="controller"/>

	<xsl:template match="/rdf:RDF">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<xsl:text disable-output-escaping="yes">&lt;/META&gt;</xsl:text>
				<title>DAMS4 Data Review</title>
				
				<style>
					body {text-align: center;font-family: Arial, Helvetica, sans-serif;font-size: 12px; font-weight: normal;}
					div {margin-bottom: 12px;}
					a {text:align: left;}
					.view {float: right; font-weight: bold; font-size: 16px; text-decoration: none;padding: 0px 5px;}
					.property_1_label a {text:align: left; text-decoration: none;}
					.property_1_value {text-align: left;background-color: #eee;min-width: 100px;padding:3px 5px;}					
					.property_1_label {text-align: left;background-color: #eee;padding: 3px 5px;width: 132px;font-weight: bold;}
					.property_2_value {text-align: left;padding: 2px 5px;}
					.property_2_label {margin-left:15;text-align: left;width: 132px;padding: 2px 5px;white-space: nowrap;}
					.property_3_value {text-align: left;padding: 2px 5px;}
					.property_3_label {margin-left:15;text-align: left;width: 132px;padding: 2px 5px;font-weight: bold;}
					.propertyBox {width: 1000px;align: center;}
					.record {font-size: 16px;font-weight: bold;text-align: left;background-color: #444;padding-left: 5px;color: #FFF;width: 140px;height:24px;}
					.recordValue {background-color: #444;color: #FFF;width: 500px;padding-left:10px;}
					.subGroup{margin-bottom:12px; padding: 0px;}
										
					ul {list-style-type: none; border-bottom: none; border-right: none; padding:0px 0px 0px 60px; margin: 0px;}
					li {list-style-type: none;margin:0px;padding:0px;width:100%;border: none;}
					table {border-collapse:collapse;width:100%;cell-spacing:0px;cell-padding:0px;margin:0px;padding:0px;}
					tr {border-bottom: 1px solid #bbb;border-top: 1px solid #bbb;border-right: 1px solid #bbb;}
					td {border-left: 1px solid #bbb;}
					h4 {margin-bottom: 0.25em; }
					

					.title {font-size: 24px;text-align: center;color: #333;}
					
				</style>
			</head>
		
			<body>
				<xsl:for-each select="*">
					<xsl:variable name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:variable>
				  	<xsl:variable name="viewUrl">
						<xsl:choose>
							<xsl:when test="string-length($controller) > 0"><xsl:value-of select="concat('../', $ark, '/data_view?xsl=review_tree.xsl')"/></xsl:when>
							<xsl:when test="string-length($baseurl) > 0"><xsl:value-of select="concat($baseurl, '/api/objects/', $ark, '/transform?recursive=true&amp;xsl=review_tree.xsl')" /></xsl:when>
					  		<xsl:otherwise><xsl:value-of select="concat('/dams/api/objects/', $ark, '/transform?recursive=true&amp;xsl=review_tree.xsl')" /></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<table>
						<tr style="border: none;">
							<td align="center">
								<div class="title">UC San Diego Library DAMS Data View</div>
								<div style="width: 1000px;padding-bottom:8px;"><a href="{$viewUrl}" target="_blank" class="view">Tree View</a></div>
								<div class="propertyBox" >
									<xsl:call-template name="damsResource"/>
									<ul style="border: none;padding-top: 10px;padding-left: 0;">
										<xsl:choose>
											<xsl:when test="contains(local-name(), 'Collection')">
												<xsl:variable name="collectionsUrlBase">
											  		<xsl:choose>
											  			<xsl:when test="string-length($baseurl) > 0 and starts-with($baseurl, 'http')"><xsl:value-of select="$baseurl" /></xsl:when>
											  			<xsl:otherwise>http://localhost:8080/dams</xsl:otherwise>
											  		</xsl:choose>
											  	</xsl:variable>
												<xsl:variable name="docCollections" select="document(concat($collectionsUrlBase, '/api/collections'))"/>
												<xsl:call-template name="topElements">
													<xsl:with-param name="collections" select="$docCollections/response/collections"/>
													<xsl:with-param name="depth">1</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="topElements">
													<xsl:with-param name="depth">1</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</ul>
								</div>
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	 
	<xsl:template name="damsResource">
		<div>
			<table>
				<tr>
					<td class="record"><xsl:value-of select="local-name()"/></td>
					<td class="recordValue"><xsl:value-of select="@rdf:about"/></td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="topElements">
		<xsl:param name="depth"/>
		<xsl:param name="collections" />
			<xsl:for-each select="*[name()='mads:authoritativeLabel']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='isMemberOfMADSScheme']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='componentList']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='elementList']">
					<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='unit']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='typeOfResource']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:if test="$depth = 1 or dams:label">
				<xsl:for-each select="*[local-name()='title' or contains(local-name(), 'Title')]">
					<xsl:call-template name="damsElement"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="*[local-name()='relationship' or contains(local-name(), 'Relationship')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='date' or contains(local-name(), 'Date')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name() = 'topic' or local-name() = 'temporal' or local-name() = 'occupation' or local-name() = 'geographic' or local-name() = 'genreForm' or local-name() = 'complexSubject']">
				<xsl:sort select="name()" order="descending"/>
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='note' or local-name()='hasNote']">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[contains(local-name(), 'Note')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='language' or contains(local-name(), 'Language')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name() = 'collection' or contains(local-name(), 'Collection') or local-name() = 'hasPart']">
				<xsl:call-template name="damsElement">
					<xsl:with-param name="collections" select="$collections"/>
				</xsl:call-template>
			</xsl:for-each>	
			<xsl:for-each select="*[local-name()='relatedResource' or contains(local-name(), 'RelatedResource')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='copyright' or contains(local-name(), 'Copyright')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[starts-with(local-name(), 'rightsHolder')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='otherRights' or contains(local-name(), 'OtherRights')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='license' or contains(local-name(), 'License')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='statute' or contains(local-name(), 'Statute')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='visibility' or contains(local-name(), 'visibility')]">
				<xsl:call-template name="damsElement"/>
			</xsl:for-each>
			<xsl:for-each select="*[contains(local-name(), 'hasFile')]">
				<xsl:if test="contains(dams:File/dams:use, '-source') or contains(dams:File/@rdf:about, '/1.')">
					<xsl:call-template name="damsElement"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="*[local-name()='component' or contains(local-name(), 'Component')]/*[local-name()='Component']">
				<xsl:sort select="dams:order" data-type="number" order="ascending" />
				<li>
					<ul>
						<xsl:if test="$depth=1"><xsl:attribute name="class">subGroup</xsl:attribute></xsl:if>
						<xsl:call-template name="damsComponent">
							<xsl:with-param name="depth"><xsl:value-of select="$depth"/></xsl:with-param>
						</xsl:call-template>
					</ul>
				</li>
			</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsElement">
		<xsl:param name="collections"/>
		<xsl:variable name="resid"><xsl:value-of select="@rdf:resource | @rdf:about"/></xsl:variable>
		<xsl:variable name="predicate"><xsl:value-of select="local-name()"/></xsl:variable>
		<li>
			<div>
				<table>
					<xsl:choose>
						<xsl:when test="string-length($resid) > 0 and //*[@rdf:about=$resid]">
							<xsl:for-each select="//*[@rdf:about=$resid]">
								<xsl:if test="*">
									<xsl:choose>
									<xsl:when test="starts-with($predicate, 'rightsHolder')">
										<xsl:call-template name="damsRightsHolder"/>
									</xsl:when>
									<xsl:when test="local-name() = 'Unit'">
										<xsl:call-template name="damsUnit"/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Collection')">
										<xsl:call-template name="damsCollection"/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Title')">
										<xsl:apply-templates select=".."/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Note') and local-name() != 'Note'">
										<xsl:call-template name="damsDerivedNote"/>
									</xsl:when>
									<xsl:when test="contains(local-name(),'MADSScheme')">
										<xsl:apply-templates select=".."/>
									</xsl:when>
									<xsl:when test="starts-with(name(), 'mads')">
										<xsl:call-template name="madsElement"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select=".."/>
									</xsl:otherwise>
								</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="@rdf:resource or @rdf:about">
							<xsl:call-template name="unknownElement">
								<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:resource|@rdf:about, '/20775/')"/></xsl:with-param>
								<xsl:with-param name="propName"><xsl:value-of select="local-name()"/></xsl:with-param>
								<xsl:with-param name="collections" select="$collections"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="local-name() = 'elementList'">
							<xsl:call-template name="madsElementList">
								<xsl:with-param name="class">property_1</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="starts-with($predicate, 'rightsHolder')">
							<xsl:call-template name="damsRightsHolder"/>
						</xsl:when>
						<xsl:when test="*">
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="local-name() = 'Unit'">
										<xsl:copy-of select="damsUnit"/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Collection')">
										<xsl:call-template name="damsCollection"/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Title')">
										<xsl:apply-templates select=".."/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'Note') and local-name() != 'Note'">
										<xsl:call-template name="damsDerivedNote"/>
									</xsl:when>
									<xsl:when test="contains(local-name(), 'MADSScheme')">
										<xsl:apply-templates select=".."/>
									</xsl:when>
									<xsl:when test="starts-with(name(), 'mads')">
										<xsl:call-template name="madsElement"/>
									</xsl:when>
									<xsl:when test="starts-with(local-name(), 'relationship')">
										<xsl:call-template name="damsRelationship"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select=".."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="local-name() = 'visibility'">
							<xsl:call-template name="damsVisibility"></xsl:call-template>
						</xsl:when>
						<xsl:when test="local-name() = 'typeOfResource'">
							<xsl:call-template name="damsTypeOfResource"></xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</div>
		</li>
	</xsl:template>
	<xsl:template name="madsTitle" match="mads:Title">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="mads:authoritativeLabel"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="*[contains(name(), 'Variant')]/mads:Variant">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
				<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="mads:variantLabel"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsRelationship" match="dams:Relationship">
		<xsl:call-template name="damsPropertyTitle">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:role">
			<xsl:choose>
				<xsl:when test="@rdf:resource">
					<xsl:call-template name="rdfResource">
						<xsl:with-param name="class">property_2</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="*[local-name()='Authority']">
						<xsl:call-template name="madsElement">
							<xsl:with-param name="class">property_2</xsl:with-param>
							<xsl:with-param name="propName">Role</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="*[contains(local-name(), 'Name')]">
			<xsl:choose>
				<xsl:when test="@rdf:resource">
					<xsl:call-template name="rdfResource">
						<xsl:with-param name="class">property_2</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="*[contains(local-name(), 'Name')]">
						<xsl:call-template name="madsElement">
							<xsl:with-param name="class">property_2</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsDate" match="dams:Date">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:type"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="rdf:value">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Value</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:beginDate">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">BeginDate</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:endDate">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">EndDate</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsNote" match="dams:Note">
		<xsl:call-template name="damsPropertyTitle">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:type">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Type</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:displayLabel">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">DisplayLabel</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="rdf:value">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Value</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsDerivedNote">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="rdf:value"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsLanguage" match="dams:Language">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="mads:authoritativeLabel"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsUnit">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:unitName"/></xsl:with-param>
			<xsl:with-param name="view">dataview</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsCollection">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:title/mads:Title/mads:authoritativeLabel"/></xsl:with-param>
			<xsl:with-param name="view">dataview</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsRelatedResource" match="dams:RelatedResource">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:type"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:description">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
				<xsl:with-param name="name">description</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:uri">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="ark"><xsl:value-of select="@rdf:resource|text()"/></xsl:with-param>
				<xsl:with-param name="name">URI</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="@rdf:resource|text()"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
				<xsl:with-param name="view">xml</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsCopyright" match="dams:Copyright">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:copyrightStatus"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:copyrightJursidiction">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">copyrightJursidiction</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsRightsHolder">
		<xsl:choose>
			<xsl:when test="@rdf:resource">
				<xsl:call-template name="rdfResource">
					<xsl:with-param name="propName">RightsHolder</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="*[contains(local-name(), 'Name')]">
					<xsl:call-template name="madsElement">
						<xsl:with-param name="propName">RightsHolder</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="damsOtherRights" match="dams:OtherRights">
		<xsl:call-template name="damsPropertyTitle">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:permission">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Permission</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="dams:Permission/dams:type"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:restriction">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Restriction</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="dams:Restriction/dams:type"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:otherRightsBasis">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">OtherRightsBasis</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsLicense" match="dams:License">
		<xsl:call-template name="damsPropertyTitle">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:permission">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Permission</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="dams:Permission/dams:type"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:restriction">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">Restriction</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="dams:Restriction/dams:type"/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="//dams:beginDate">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">BeginDate</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="//dams:endDate">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">EndDate</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsStatute" match="dams:Statute">
		<xsl:call-template name="damsPropertyTitle">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="dams:statuteCitation">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">statuteCitation</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:statuteJurisdiction">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">statuteJurisdiction</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="dams:statuteNote">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="name">statuteNote</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
				<xsl:with-param name="class">property_2</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsTypeOfResource" match="dams:typeOfResource">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="name">TypeOfResource</xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsVisibility" match="dams:visibility">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="madsAuthoritativeLabel" match="mads:authoritativeLabel">
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsFile" match="dams:File">
		<xsl:param name="class"/>
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="dams:use"/></xsl:with-param>
			<xsl:with-param name="class">property_2</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
	<xsl:template name="madsElement">
		<xsl:param name="class"/>
		<xsl:param name="propName"/>
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name">
				<xsl:choose>
					<xsl:when test="$propName"><xsl:value-of select="$propName"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="mads:authoritativeLabel"/></xsl:with-param>
			<xsl:with-param name="class"><xsl:value-of select="$class"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="madsMADSScheme" match="mads:MADSScheme">
		<xsl:param name="class"/>
		<xsl:param name="propName"/>
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
			<xsl:with-param name="name">
				<xsl:choose>
					<xsl:when test="$propName"><xsl:value-of select="$propName"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="mads:code"/></xsl:with-param>
			<xsl:with-param name="class"><xsl:value-of select="$class"/></xsl:with-param>
			<xsl:with-param name="view">xml</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="madsElementList">
		<xsl:param name="class"/>
		<xsl:param name="propName"/>
		<xsl:for-each select="*">
			<xsl:call-template name="damsProperty">
				<xsl:with-param name="ark"><xsl:value-of select="substring-after(@rdf:about, '/20775/')"/></xsl:with-param>
				<xsl:with-param name="name">
					<xsl:choose>
						<xsl:when test="$propName"><xsl:value-of select="$propName"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="val"><xsl:value-of select="mads:elementValue"/></xsl:with-param>
				<xsl:with-param name="class"><xsl:value-of select="$class"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="rdfResource">
		<xsl:param name="propName"/>
		<xsl:param name="class"/>
		<xsl:variable name="resid"><xsl:value-of select="@rdf:resource"/></xsl:variable>
		<xsl:for-each select="//*[@rdf:about=$resid]">
			<xsl:if test="*">
				<xsl:choose>
					<xsl:when test="starts-with(name(), 'mads')">
						<xsl:call-template name="madsElement">
							<xsl:with-param name="propName"><xsl:value-of select="$propName"/></xsl:with-param>
							<xsl:with-param name="class"><xsl:value-of select="$class"/></xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise><xsl:apply-templates select=".."/></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="damsComponent">
		<xsl:param name="depth"/>
		<xsl:variable name="curDepth">
			<xsl:choose>
				<xsl:when test="string-length($depth) = 0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="$depth + 1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$depth = 1">
			<li>
				<table>
					<xsl:call-template name="damsPropertyTitle">
						<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
						<xsl:with-param name="name"><xsl:value-of select="local-name()"/></xsl:with-param>
					</xsl:call-template>
				</table>
			</li>
		</xsl:if>
		<li>
			<table>
				<xsl:call-template name="damsPropertyTitle">
					<xsl:with-param name="ark"><xsl:value-of select="@rdf:about"/></xsl:with-param>
					<xsl:with-param name="name"><xsl:value-of select="dams:order"/></xsl:with-param>
					<xsl:with-param name="val"><xsl:value-of select="dams:label | dams:title/mads:Title/mads:authoritativeLabel"/></xsl:with-param>
					<xsl:with-param name="class">property_3</xsl:with-param>
				</xsl:call-template>
			</table>
		</li>
		<xsl:call-template name="topElements">
			<xsl:with-param name="depth"><xsl:value-of select="$curDepth"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="damsProperty">
		<xsl:param name="ark" />
		<xsl:param name="name" />
		<xsl:param name="val" />
		<xsl:param name="class" />
		<xsl:param name="view" />
		<xsl:variable name="className">
			<xsl:choose>
				<xsl:when test="$class"><xsl:value-of select="$class"/></xsl:when>
				<xsl:otherwise>property_1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<td class="{$className}_label"><xsl:value-of select="$name"/></td>
			
			<xsl:variable name="viewUrlBase">
		  		<xsl:choose>
		  			<xsl:when test="string-length($baseurl) > 0"><xsl:value-of select="$baseurl" /></xsl:when>
		  			<xsl:otherwise>/dams</xsl:otherwise>
		  		</xsl:choose>
		  	</xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length($ark) > 0 and starts-with($ark, 'http')">
					<td class="{$className}_value">
						<a href="{$ark}">
							<xsl:choose>
						    	<xsl:when test="contains($val, '&amp;')"><xsl:text disable-output-escaping="yes"><xsl:value-of select="translate($val, '&amp;', '&amp;amp;')"/></xsl:text></xsl:when>
								<xsl:otherwise><xsl:value-of select="$val" disable-output-escaping="yes"/></xsl:otherwise>
						    </xsl:choose>
						</a>
					</td>
				</xsl:when>
				<xsl:when test="string-length($ark) > 0">
					<xsl:variable name="xsl">
						<xsl:choose>
							<xsl:when test="$view = 'dataview'">review.xsl</xsl:when>
							<xsl:otherwise>normalize.xsl</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="viewUrl">
						<xsl:choose>
							<xsl:when test="string-length($controller) > 0 and $view = 'dataview'"><xsl:value-of select="concat('../', $ark, '/data_view?xsl=', $xsl)"/></xsl:when>
							<xsl:when test="string-length($baseurl) > 0"><xsl:value-of select="concat($baseurl, '/api/objects/', $ark, '/transform?recursive=true&amp;xsl=', $xsl)" /></xsl:when>
					  		<xsl:otherwise><xsl:value-of select="concat('/dams/api/objects/', $ark, '/transform?recursive=true&amp;xsl=', $xsl)" /></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<td class="{$className}_value">
					    <xsl:text> </xsl:text>
						<a href="{$viewUrl}">
							<xsl:choose>
						    	<xsl:when test="contains($val, '&amp;')"><xsl:text disable-output-escaping="yes"><xsl:value-of select="translate($val, '&amp;', '&amp;amp;')"/></xsl:text></xsl:when>
								<xsl:otherwise><xsl:value-of select="$val" disable-output-escaping="yes"/></xsl:otherwise>
						    </xsl:choose>
						</a>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="{$className}_value">
						<xsl:choose>
					    	<xsl:when test="contains($val, '&amp;')"><xsl:text disable-output-escaping="yes"><xsl:value-of select="translate($val, '&amp;', '&amp;amp;')"/></xsl:text></xsl:when>
							<xsl:otherwise><xsl:value-of select="$val" disable-output-escaping="yes"/></xsl:otherwise>
					    </xsl:choose>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>
	<xsl:template name="damsPropertyTitle">
		<xsl:param name="ark" />
		<xsl:param name="name" />
		<xsl:param name="val" />
		<xsl:param name="class" />
		<xsl:variable name="className">
			<xsl:choose>
				<xsl:when test="$class"><xsl:value-of select="$class"/></xsl:when>
				<xsl:otherwise>property_1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:choose>
				<xsl:when test="string-length($ark) > 0">
					<td class="{$className}_label"><span title="{$ark}" style="cursor: pointer;"><xsl:value-of select="$name"/></span></td>
				</xsl:when>
				<xsl:otherwise>
					<td class="{$className}_label"><xsl:value-of select="$name"/></td>
				</xsl:otherwise>
			</xsl:choose>
			<td class="{$className}_value">
				<xsl:choose>
			    	<xsl:when test="contains($val, '&amp;')"><xsl:text disable-output-escaping="yes"><xsl:value-of select="translate($val, '&amp;', '&amp;amp;')"/></xsl:text></xsl:when>
					<xsl:otherwise><xsl:value-of select="$val" disable-output-escaping="yes"/></xsl:otherwise>
			    </xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="unknownElement">
		<xsl:param name="ark"/>
		<xsl:param name="propName"/>
		<xsl:param name="collections"/>
		<xsl:variable name="collection" select="$collections/value[contains(collection,$ark)]"/>
		<xsl:variable name="uTitle">
			<xsl:choose>
				<xsl:when test="$collection"><xsl:value-of select="$collection/title"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$ark"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uType">
			<xsl:choose>
				<xsl:when test="$collection"><xsl:value-of select="$collection/type"/></xsl:when>
				<xsl:when test="starts-with($propName, 'has')"><xsl:value-of select="substring-after($propName, 'has')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$propName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="damsProperty">
			<xsl:with-param name="ark"><xsl:value-of select="$ark"/></xsl:with-param>
			<xsl:with-param name="name"><xsl:value-of select="$uType"/></xsl:with-param>
			<xsl:with-param name="val"><xsl:value-of select="$uTitle"/></xsl:with-param>
			<xsl:with-param name="class">property_1</xsl:with-param>
			<xsl:with-param name="view">
				<xsl:choose>
					<xsl:when test="contains($uType, 'Collection') or contains($uType, 'collection')">dataview</xsl:when>
					<xsl:otherwise>xml</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
