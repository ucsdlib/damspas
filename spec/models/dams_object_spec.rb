require 'spec_helper'

describe DamsObject do
  
  before  do
    #@damsObj = DamsObject.new(pid: 'bb52572546') # nuking test record needed for other tests...
    @damsObj = DamsObject.new(pid: 'xx00000001')
  end
  
  it "should have the specified datastreams" do
    @damsObj.datastreams.keys.should include("damsMetadata")
    @damsObj.damsMetadata.should be_kind_of DamsObjectDatastream
  end
  
  it "should create/update a title" do
    @damsObj.title.build
    #@damsObj.titleValue.should == []
    @damsObj.titleValue = "Dams Object Title 1"
    @damsObj.titleValue.should == "Dams Object Title 1"
  
    @damsObj.titleValue = "Dams Object Title 2"
    @damsObj.titleValue.should == "Dams Object Title 2"
  end

  it "should create/update a subject" do
    @damsObj.topic.build
    @damsObj.topic.first.name = "topic 1"
    @damsObj.topic.first.name.should == ["topic 1"]
    @damsObj.topic << MadsTopic.new( :name => "topic 2" )
    pending "should be able to access second and subsequent topics..."
    @damsObj.topic[1].name.should == ["topic 2"]

    @damsObj.topic.first.name = "topic 3"
    @damsObj.topic.first.name.should == ["topic 3"]
    @damsObj.topic.second.name = "topic 4"
    @damsObj.topic.second.name.should == ["topic 4"]
  end

  describe "Store to a repository" do
    before do
      MadsPersonalName.create! pid: "zzXXXXXXX1", name: "Maria", externalAuthority: "someUrl"
    end
    after do
      #@damsObj.delete
    end
    it "should store/retrieve from a repository" do
      @damsObj.damsMetadata.content = File.new('spec/fixtures/dissertation.rdf.xml').read
      @damsObj.save!
      @damsObj.reload
      loadedObj = DamsObject.find(@damsObj.pid)
      loadedObj.titleValue.should == "Chicano and black radical activism of the 1960s"
    end
  end

  it "should load a complex object from RDF/XML file" do
    obj = DamsObject.find('bb80808080')
    obj.titleValue.should == "Sample Complex Object Record #1"
    obj.component.first.title.first.value.should == "Supplementary Image"
  end
	exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85148221"
	topic_uri = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd46424836"
	topic_uri_2 = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/xx00000999"
	
  let(:params) {	
    {  
       title_attributes: [
    	  name: "Sample Complex Object Record #1",
          mainTitleElement_attributes: [{ elementValue: "Sample Complex Object Record #1" }],
          subTitleElement_attributes: [{ elementValue: "a newspaper PDF with a single attached image" }],
          hasVariant_attributes: [{ variantLabel: "The Whale" }],
          hasTranslationVariant_attributes: [{ variantLabel: "Translation Variant" }],
          hasAbbreviationVariant_attributes: [{ variantLabel: "Abbreviation Variant" }],
          hasAcronymVariant_attributes: [{ variantLabel: "Acronym Variant" }],
          hasExpansionVariant_attributes: [{ variantLabel: "Expansion Variant" }]
        ],
        date_attributes: [value: "May 24, 1980", beginDate: "1980-05-24",endDate: "1980-05-24"],
        relationship_attributes: [name: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX1"),role: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX2")],
        language_attributes: [{name: "TestLang", code: "test"}],
        #language: RDF::Resource.new("#{Rails.configuration.id_namespace}xx00000170"),
        note_attributes:[displayLabel: "ARK ID", value: "http://library.ucsd.edu/ark:/20775/bb80808080", type: "identifier"],  
        custodialResponsibilityNote_attributes:[displayLabel: "Digital object made available by", value: "Mandeville Special Collections Library", type: "custodial_history"],  
        preferredCitationNote_attributes:[displayLabel: "Citation", value: "Data at Redshift=1.4 (RD0022)", type: "citation"],  
        scopeContentNote_attributes:[displayLabel: "Scope and contents", value: "Electronic theses and dissertations submitted by UC San Diego students", type: "scope_and_content"],     
        complexSubject_attributes: [
        		name: "World politics--American politics--20th Century",
		        topic_attributes: [
		        	{name:"World politics", externalAuthority: exturi, 
		        	 topicElement_attributes: [{ elementValue: "World politics" }]
			        },
		        	{id: topic_uri_2, name:"American politics", externalAuthority: exturi,
		        	 topicElement_attributes: [{ elementValue: "American politics" }]
		        	}
		        ],
		        temporal_attributes: [
		        	{name:"20th Century",  temporalElement_attributes: [{ elementValue: "20th Century" }]}
		        ],
		        genreForm_attributes: [
		        	{name:"genreFormValue",  genreFormElement_attributes: [{ elementValue: "genreFormValue" }]}
		        ],
				personalName_attributes: [
		        	{name:"Burns", familyNameElement_attributes: [{ elementValue: "Burns" }]}
		        ],
				genericName_attributes: [
		        	{name:"genericNameValue", givenNameElement_attributes: [{ elementValue: "genericNameValue" }]}
		        ]		      
        ],
        topic_attributes: [name: "test subject"],
        name_attributes: [name: "inline name"],
        personalName_attributes: [name: "inline personal name"],
        corporateName_attributes: [name: "inline corporate name"],
        conferenceName_attributes: [name: "inline conference name"],
        familyName_attributes: [name: "inline family name"],
        relatedResource_attributes: [type: "online exhibit", description: "Sample Complex Object Record #1: The Exhibit!", uri: "http://foo.com/1234"],
        unit_attributes: [name: "Research Data Curation Program", description: "ResearchCyberinfrastructure (RCI) is a UCSD-sponsored program", uri: "http://rci.ucsd.edu/", code: "rci"],
		assembledCollectionURI: ["bb03030303"],
		provenanceCollectionURI: ["bb24242424"],
		copyrightURI: ["bb05050505"],
		statuteURI: ["bb21212121"],
		otherRightsURI: ["bb06060606"],
		licenseURI: ["bb22222222"],
		rightsHolderURI: ["bb09090909"],
		rightsHolderPersonal_attributes: [name: "inline personal rightsHolder name"],
		#rightsHolderCorporate_attributes: [name: "inline corporate rightsHolder name"],
		typeOfResource: "text",
		cartographics_attributes: [point: "29.67459,-82.37873", line: "123", polygon: "456", projection: "equirectangular", referenceSystem: "WGS84", scale: "1:20000"]
  }}
  subject do
    DamsObject.new(pid: 'xx80808080').tap do |t|
      t.attributes = params
    end
  end

  it "should create a rdf/xml" do
#    subject.titleValue = "Sample Complex Object Record #1"
#    subject.subtitle = "a newspaper PDF with a single attached image"
#    subject.titleVariant = "The Whale"
#    subject.titleTranslationVariant = "Translation Variant"
#    subject.titleAbbreviationVariant = "Abbreviation Variant"
#    subject.titleAcronymVariant = "Acronym Variant"
#    subject.titleExpansionVariant = "Expansion Variant"
#    subject.dateValue = "May 24, 1980"
#    subject.beginDate = "1980-05-24"
#    subject.endDate = "1980-05-24"
#    subject.subjectValue = ["Black Panther Party--History"]
#    subject.subjectURI = ["bd6724414c"]
#    subject.topic.build.name = "test subject"
#    subject.languageURI = ["xx00000170"]
#    subject.assembledCollectionURI = ["bb03030303"]
#    subject.provenanceCollectionURI = ["bb24242424"]
#    subject.relationshipRoleURI = ["bd8396905c"]
#    subject.relationshipNameType = ["CorporateName"]
#    subject.relationshipNameURI = ["bd8294487v"]      
#    subject.nameType = ["PersonalName"]
#    subject.nameURI = ["xx11111111"]
#    subject.nameTypeValue = ["inline personal name"]
#    subject.copyrightURI = ["bb05050505"]
#    subject.statuteURI = ["bb21212121"]
#    subject.otherRightsURI = ["bb06060606"]
#    subject.licenseURI = ["bb22222222"]
#    subject.rightsHolderURI = ["bb09090909"]
	bn_id = subject.title[0].hasVariant[0].rdf_subject.id
    bn_id_trans = subject.title[0].hasTranslationVariant[0].rdf_subject.id
    bn_id_abb = subject.title[0].hasAbbreviationVariant[0].rdf_subject.id
    bn_id_acro = subject.title[0].hasAcronymVariant[0].rdf_subject.id
    bn_id_exp = subject.title[0].hasExpansionVariant[0].rdf_subject.id

    xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
<dams:Object rdf:about="http://library.ucsd.edu/ark:/20775/xx80808080">
   <dams:assembledCollection rdf:resource="http://library.ucsd.edu/ark:/20775/bb03030303"/>
   <dams:cartographics>
     <dams:Cartographics>
       <dams:line>123</dams:line>
       <dams:point>29.67459,-82.37873</dams:point>
       <dams:polygon>456</dams:polygon>
       <dams:projection>equirectangular</dams:projection>
       <dams:referenceSystem>WGS84</dams:referenceSystem>
       <dams:scale>1:20000</dams:scale>
     </dams:Cartographics>
   </dams:cartographics>
   <dams:complexSubject>
     <mads:ComplexSubject>
       <mads:authoritativeLabel>World politics--American politics--20th Century</mads:authoritativeLabel>
       <mads:componentList rdf:parseType="Collection">
         <mads:Topic>
           <mads:authoritativeLabel>World politics</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:TopicElement>
               <mads:elementValue>World politics</mads:elementValue>
             </mads:TopicElement>
           </mads:elementList>
           <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85148221"/>
         </mads:Topic>
         <mads:Topic rdf:about="http://library.ucsd.edu/ark:/20775/xx00000999">
           <mads:authoritativeLabel>American politics</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:TopicElement>
               <mads:elementValue>American politics</mads:elementValue>
             </mads:TopicElement>
           </mads:elementList>
           <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85148221"/>
         </mads:Topic>
         <mads:Temporal>
           <mads:authoritativeLabel>20th Century</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:TemporalElement>
               <mads:elementValue>20th Century</mads:elementValue>
             </mads:TemporalElement>
           </mads:elementList>
         </mads:Temporal>
         <mads:GenreForm>
           <mads:authoritativeLabel>genreFormValue</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:GenreFormElement>
               <mads:elementValue>genreFormValue</mads:elementValue>
             </mads:GenreFormElement>
           </mads:elementList>
         </mads:GenreForm>
         <mads:PersonalName>
           <mads:authoritativeLabel>Burns</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:FamilyNameElement>
               <mads:elementValue>Burns</mads:elementValue>
             </mads:FamilyNameElement>
           </mads:elementList>
         </mads:PersonalName>
         <mads:Name>
           <mads:authoritativeLabel>genericNameValue</mads:authoritativeLabel>
           <mads:elementList rdf:parseType="Collection">
             <mads:GivenNameElement>
               <mads:elementValue>genericNameValue</mads:elementValue>
             </mads:GivenNameElement>
           </mads:elementList>
         </mads:Name>
       </mads:componentList>
     </mads:ComplexSubject>
   </dams:complexSubject>
   <dams:conferenceName>
     <mads:ConferenceName>
       <mads:authoritativeLabel>inline conference name</mads:authoritativeLabel>
     </mads:ConferenceName>
   </dams:conferenceName>
   <dams:copyright rdf:resource="http://library.ucsd.edu/ark:/20775/bb05050505"/>
   <dams:corporateName>
     <mads:CorporateName>
       <mads:authoritativeLabel>inline corporate name</mads:authoritativeLabel>
     </mads:CorporateName>
   </dams:corporateName>
   <dams:custodialResponsibilityNote>
     <dams:CustodialResponsibilityNote>
       <dams:displayLabel>Digital object made available by</dams:displayLabel>
       <dams:type>custodial_history</dams:type>
       <rdf:value>Mandeville Special Collections Library</rdf:value>
     </dams:CustodialResponsibilityNote>
   </dams:custodialResponsibilityNote>
   <dams:date>
     <dams:Date>
       <dams:beginDate>1980-05-24</dams:beginDate>
       <dams:endDate>1980-05-24</dams:endDate>
       <rdf:value>May 24, 1980</rdf:value>
     </dams:Date>
   </dams:date>
   <dams:familyName>
     <mads:FamilyName>
       <mads:authoritativeLabel>inline family name</mads:authoritativeLabel>
     </mads:FamilyName>
   </dams:familyName>
   <dams:language>
     <mads:Language>
       <mads:authoritativeLabel>TestLang</mads:authoritativeLabel>
       <mads:code>test</mads:code>
     </mads:Language>
   </dams:language>
   <dams:license rdf:resource="http://library.ucsd.edu/ark:/20775/bb22222222"/>
   <dams:name>
     <mads:Name>
       <mads:authoritativeLabel>inline name</mads:authoritativeLabel>
     </mads:Name>
   </dams:name>
   <dams:note>
     <dams:Note>
       <dams:displayLabel>ARK ID</dams:displayLabel>
       <dams:type>identifier</dams:type>
       <rdf:value>http://library.ucsd.edu/ark:/20775/bb80808080</rdf:value>
     </dams:Note>
   </dams:note>
   <dams:otherRights rdf:resource="http://library.ucsd.edu/ark:/20775/bb06060606"/>
   <dams:personalName>
     <mads:PersonalName>
       <mads:authoritativeLabel>inline personal name</mads:authoritativeLabel>
     </mads:PersonalName>
   </dams:personalName>
   <dams:preferredCitationNote>
     <dams:PreferredCitationNote>
       <dams:displayLabel>Citation</dams:displayLabel>
       <dams:type>citation</dams:type>
       <rdf:value>Data at Redshift=1.4 (RD0022)</rdf:value>
     </dams:PreferredCitationNote>
   </dams:preferredCitationNote>
   <dams:provenanceCollection rdf:resource="http://library.ucsd.edu/ark:/20775/bb24242424"/>
   <dams:relatedResource>
     <dams:RelatedResource>
       <dams:description>Sample Complex Object Record #1: The Exhibit!</dams:description>
       <dams:type>online exhibit</dams:type>
       <dams:uri>http://foo.com/1234</dams:uri>
     </dams:RelatedResource>
   </dams:relatedResource>
   <dams:relationship>
     <dams:Relationship>
       <dams:name rdf:resource="http://library.ucsd.edu/ark:/20775/bbXXXXXXX1"/>
       <dams:role rdf:resource="http://library.ucsd.edu/ark:/20775/bbXXXXXXX2"/>
     </dams:Relationship>
   </dams:relationship>
   <dams:rightsHolder>
     <mads:PersonalName>
       <mads:authoritativeLabel>inline personal rightsHolder name</mads:authoritativeLabel>
     </mads:PersonalName>
   </dams:rightsHolder>
   <dams:rightsHolder rdf:resource="http://library.ucsd.edu/ark:/20775/bb09090909"/>
   <dams:scopeContentNote>
     <dams:ScopeContentNote>
       <dams:displayLabel>Scope and contents</dams:displayLabel>
       <dams:type>scope_and_content</dams:type>
       <rdf:value>Electronic theses and dissertations submitted by UC San Diego students</rdf:value>
     </dams:ScopeContentNote>
   </dams:scopeContentNote>
   <dams:statute rdf:resource="http://library.ucsd.edu/ark:/20775/bb21212121"/>
   <dams:title>
     <mads:Title>
       <mads:authoritativeLabel>Sample Complex Object Record #1</mads:authoritativeLabel>
       <mads:elementList rdf:parseType="Collection">
         <mads:MainTitleElement>
           <mads:elementValue>Sample Complex Object Record #1</mads:elementValue>
         </mads:MainTitleElement>
         <mads:SubTitleElement>
           <mads:elementValue>a newspaper PDF with a single attached image</mads:elementValue>
         </mads:SubTitleElement>
       </mads:elementList>
		<mads:hasAbbreviationVariant rdf:nodeID="#{bn_id_abb}"/>
		<mads:hasAcronymVariant rdf:nodeID="#{bn_id_acro}"/>
		<mads:hasExpansionVariant rdf:nodeID="#{bn_id_exp}"/>         
		<mads:hasTranslationVariant rdf:nodeID="#{bn_id_trans}"/>
		<mads:hasVariant rdf:nodeID="#{bn_id}"/>       
     </mads:Title>
   </dams:title>
   <dams:topic>
     <mads:Topic>
       <mads:authoritativeLabel>test subject</mads:authoritativeLabel>
     </mads:Topic>
   </dams:topic>
   <dams:typeOfResource>text</dams:typeOfResource>
   <dams:unit>
     <dams:Unit>
       <dams:code>rci</dams:code>
       <dams:unitDescription>ResearchCyberinfrastructure (RCI) is a UCSD-sponsored program</dams:unitDescription>
       <dams:unitName>Research Data Curation Program</dams:unitName>
       <dams:unitURI>http://rci.ucsd.edu/</dams:unitURI>
     </dams:Unit>
   </dams:unit>
 </dams:Object>
 <mads:Variant rdf:nodeID="#{bn_id}">
   <mads:variantLabel>The Whale</mads:variantLabel>
 </mads:Variant>
 <mads:Variant rdf:nodeID="#{bn_id_trans}">
   <mads:variantLabel>Translation Variant</mads:variantLabel>
 </mads:Variant>
 <mads:Variant rdf:nodeID="#{bn_id_abb}">
   <mads:variantLabel>Abbreviation Variant</mads:variantLabel>
 </mads:Variant>
 <mads:Variant rdf:nodeID="#{bn_id_acro}">
   <mads:variantLabel>Acronym Variant</mads:variantLabel>
 </mads:Variant>
 <mads:Variant rdf:nodeID="#{bn_id_exp}">
   <mads:variantLabel>Expansion Variant</mads:variantLabel>
 </mads:Variant>            
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end  
end
