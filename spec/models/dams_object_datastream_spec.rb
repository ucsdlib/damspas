# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsObjectDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/xx1111111x"
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/xx1111111x"
      end
      
      it "should have fields" do
        subject.resource_type.should == ["text"]
        subject.title.should == ["Chicano and black radical activism of the 1960s"]
      end

      it "should have collection" do
        #subject.collection.first.scopeContentNote.first.displayLabel == ["Scope and contents"]
        subject.collection.first.to_s.should ==  "http://library.ucsd.edu/ark:/20775/bbXXXXXXX3" 
      end

      it "should have inline subjects" do
        subject.subject.first.should == "Black Panther Party--History"
        subject.subject.second.should == "African Americans--Relations with Mexican Americans--History--20th Century"
      end
      it "should have external subjects" do
        subject.subject_node.first.should_not be_external
        subject.subject_node.second.should_not be_external
#puts         subject.subject_node.third
        subject.subject_node.third.should be_external
      end

      it "should have relationship" do
        subject.relationship.first.name.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX1"
        subject.relationship.first.role.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd55639754"
      end

      it "should have date" do
        subject.date.should == ["2010"]
      end

      it "should create a solr document" do
        MadsComplexSubject.should_receive(:find).with('bbXXXXXXX5').and_return(stub(:name =>'stubbed'))
        #stub_person = stub(:name => "Maria")
        #DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)        
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century","stubbed"]
        solr_doc["title_tesim"].should == ["Chicano and black radical activism of the 1960s"]
        solr_doc["date_1_value_tesim"].should == ["2010"]
        solr_doc["name_tesim"].should == ["Yañez, Angélica María"]
      end

    end

    describe "a complex object with flat component list" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'bb80808080', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bb80808080"
      end
      it "should have a repeated date" do
        solr_doc = subject.to_solr
        solr_doc["date_1_value_tesim"].should == ["2013"]
        solr_doc["date_1_beginDate_tesim"].should == ["2013"]
        solr_doc["date_1_endDate_tesim"].should == ["2013"]
        solr_doc["date_2_value_tesim"].should == ["2012"]
        solr_doc["date_2_beginDate_tesim"].should == ["2012"]
        solr_doc["date_2_endDate_tesim"].should == ["2012"]
      end     
      it "should have fields" do
        subject.resource_type.should == ["mixed material"]
        subject.title.should == ["Sample Complex Object Record #1"]
        subject.subtitle.should == ["a dissertation with a single attached image"]
        subject.relatedResource.first.type.should == ["online exhibit"]
        subject.relatedResource.first.uri.should == ["http://foo.com/1234"]
        subject.relatedResource.first.description.should == ["Sample Complex Object Record #1: The Exhibit!"]
      end

	  it "should have repeated title" do
	  	solr_doc = subject.to_solr
        solr_doc["title_1_value_tesim"].should == ["Sample Complex Object Record #1"]
        solr_doc["title_1_subtitle_tesim"].should == ["a dissertation with a single attached image"]
         solr_doc["title_2_value_tesim"].should == ["Other Title #2"]
        solr_doc["title_2_subtitle_tesim"].should == ["Subtitle #2"]
	  end
	  
      it "should have inline subjects" do
        subject.subject.first.should == "Black Panther Party--History"
      end

      it "should have relationship" do
        subject.relationship.first.name.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX1"
        subject.relationship.first.role.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd55639754"
      end

      it "should have components with type DAMS.Component" do
        DamsObjectDatastream::Component.rdf_type.should == DAMS.Component
      end

      it "should have a first component with basic metadata" do
        subject.component.first.title.first.value.should == ["The Static Image"]
        subject.component.first.title.first.subtitle.should == ["Foo!"]
        subject.component.first.title.first.type.should == ["main"]
        subject.component.first.date.first.value.should == ["June 24-25, 2012"]
        subject.component.first.date.first.beginDate.should == ["2012-06-24"]
        subject.component.first.date.first.endDate.should == ["2012-06-25"]
        subject.component.first.note.first.value.should == ["1 PDF (xi, 111 p.)"]
        subject.component.first.note.first.displayLabel.should == ["Extent"]
        subject.component.first.note.first.type.should == ["dimensions"]
      end
      it "should have a first component with two attached files" do
        subject.component.first.file.first.rdf_subject.should == "http://library.ucsd.edu/ark:/20775/bb80808080/1/1.pdf"
        subject.component.first.file.second.rdf_subject.should == "http://library.ucsd.edu/ark:/20775/bb80808080/1/2.jpg"
      end
      it "should have a first component with a first file with file metadata" do
        subject.component.first.file.first.sourcePath.should == ["src/sample/files"]
        subject.component.first.file.first.sourceFileName.should == ["comparison-1.pdf"]
        subject.component.first.file.first.formatName.should == ["PDF"]
        subject.component.first.file.first.formatVersion.should == ["1.3"]
        subject.component.first.file.first.mimeType.should == ["application/pdf"]
        subject.component.first.file.first.use.should == ["document-service"]
        subject.component.first.file.first.size.should == ["20781"]
        subject.component.first.file.first.crc32checksum.should == ["2bbbc159"]
        subject.component.first.file.first.md5checksum.should == ["733b4bf1c94e13104dab7b6c759a4a1d"]
        subject.component.first.file.first.sha1checksum.should == ["afe6fd487d598b158d593e8309d15178bba76332"]
        subject.component.first.file.first.dateCreated.should == ["2012-06-24T08:38:21-0800"]
        subject.component.first.file.first.objectCategory.should == ["file"]
        subject.component.first.file.first.compositionLevel.should == ["0"]
        subject.component.first.file.first.preservationLevel.should == ["full"]
      end
	  it "should have a first component with repeating title" do
        solr_doc = subject.to_solr
        solr_doc["component_1_1_title_tesim"].should == ["The Static Image"]
        solr_doc["component_1_1_subtitle_tesim"].should == ["Foo!"] 
        solr_doc["component_1_2_title_tesim"].should == ["The Static Image #2"]
        solr_doc["component_1_2_subtitle_tesim"].should == ["Foo! #2"] 
        solr_doc["component_1_3_title_tesim"].should == ["The Static Image #3"]
        solr_doc["component_1_3_subtitle_tesim"].should == ["Foo! #3"] 
      end
	  it "should have a second component with repeating title" do
        solr_doc = subject.to_solr
        solr_doc["component_2_1_title_tesim"].should == ["Supplementary Image"]
        solr_doc["component_2_2_title_tesim"].should == ["Supplementary Image #2"]   
      end      
	  it "should have a first component with repeating date" do
        solr_doc = subject.to_solr
        solr_doc["component_1_1_date_tesim"].should == ["June 24-25, 2012"]
        solr_doc["component_1_1_beginDate_tesim"].should == ["2012-06-24"]   
        solr_doc["component_1_1_endDate_tesim"].should == ["2012-06-25"]   
        solr_doc["component_1_2_date_tesim"].should == ["June 24-25, 2012 #2"]
        solr_doc["component_1_2_beginDate_tesim"].should == ["2012-06-24 #2"]   
        solr_doc["component_1_2_endDate_tesim"].should == ["2012-06-25 #2"] 
      end   
	  it "should have a second component with repeating date" do
        solr_doc = subject.to_solr
        solr_doc["component_2_1_date_tesim"].should == ["May 24, 2012"]
        solr_doc["component_2_1_beginDate_tesim"].should == ["2012-05-24"]   
        solr_doc["component_2_1_endDate_tesim"].should == ["2012-05-24"]   
        solr_doc["component_2_2_date_tesim"].should == ["May 24, 2012 #2"]
        solr_doc["component_2_2_beginDate_tesim"].should == ["2012-05-24 #2"]   
        solr_doc["component_2_2_endDate_tesim"].should == ["2012-05-24 #2"] 
      end              
      it "should index component metadata" do
        solr_doc = subject.to_solr
        solr_doc["component_1_1_title_tesim"].should == ["The Static Image"]
        solr_doc["component_2_1_title_tesim"].should == ["Supplementary Image"]
      end
      it "should index repeating linked metadata" do
        solr_doc = subject.to_solr
        solr_doc["language_1_id_tesim"].should == ["bd0410344f"]
        solr_doc["language_1_code_tesim"].should == ["en"]
        solr_doc["language_1_value_tesim"].should == ["English"]
        solr_doc["language_1_valueURI_tesim"].should == ["http://id.loc.gov/vocabulary/iso639-1/en"]

        # rights holder
        solr_doc["rightsHolder_1_id_tesim"].should == ["bb09090909"]
        solr_doc["rightsHolder_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
      end
      it "should index source capture" do
        solr_doc = subject.to_solr
        solr_doc["source_capture_id_tesim"].should == ["bb49494949"]
        solr_doc["source_capture_scanner_manufacturer_tesim"].should == ["Epson"]
        solr_doc["source_capture_source_type_tesim"].should == ["transmission scanner"]
        solr_doc["source_capture_scanner_model_name_tesim"].should == ["Expression 1600"]
        solr_doc["source_capture_image_producer_tesim"].should == ["Luna Imaging, Inc."]
        solr_doc["source_capture_scanning_software_version_tesim"].should == ["2.10E"]
        solr_doc["source_capture_scanning_software_tesim"].should == ["Epson Twain Pro"]
        solr_doc["source_capture_capture_source_tesim"].should == ["B&W negative , 2 1/2 x 2 1/2"]
      
      end      
      it "should index rights metadata" do
        solr_doc = subject.to_solr

        # copyright
        solr_doc["copyright_id_tesim"].should == ["bb05050505"]
        solr_doc["copyright_status_tesim"].should == ["Under copyright -- 3rd Party"]
        solr_doc["copyright_jurisdiction_tesim"].should == ["us"]
        solr_doc["copyright_note_tesim"].should == ["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."]
        solr_doc["copyright_purposeNote_tesim"].should == ["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."]
        solr_doc["copyright_beginDate_tesim"].should == ["1993-12-31"]

        # license
        solr_doc["license_id_tesim"].should == ["bb22222222"]
        solr_doc["license_note_tesim"].should == ["License note text here..."]
        solr_doc["license_uri_tesim"].should == ["http://library.ucsd.edu/licenses/lic12341.pdf"]
        solr_doc["license_permissionType_tesim"].should == ["display"]
        solr_doc["license_permissionBeginDate_tesim"].should == ["2010-01-01"]

        # statute
        solr_doc["statute_id_tesim"].should == ["bb21212121"]
        solr_doc["statute_citation_tesim"].should == ["Family Education Rights and Privacy Act (FERPA)"]
        solr_doc["statute_jurisdiction_tesim"].should == ["us"]
        solr_doc["statute_note_tesim"].should == ["Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances."]
        solr_doc["statute_restrictionType_tesim"].should == ["display"]
        solr_doc["statute_restrictionBeginDate_tesim"].should == ["1974-08-21"]

        # other rights
        solr_doc["otherRights_id_tesim"].should == ["bb06060606"]
        solr_doc["otherRights_basis_tesim"].should == ["fair use"]
        solr_doc["otherRights_uri_tesim"].should == ["http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf"]
        solr_doc["otherRights_permissionType_tesim"].should == ["display"]
        solr_doc["otherRights_permissionBeginDate_tesim"].should == ["2011-09-24"]
        solr_doc["otherRights_name_tesim"].should == ["http://library.ucsd.edu/ark:/20775/bb09090909"]
        solr_doc["otherRights_role_tesim"].should == ["http://library.ucsd.edu/ark:/20775/bd3004227d"]
      end
      it "should index unit" do
        solr_doc = subject.to_solr
        solr_doc["unit_id_tesim"].should == ["bb02020202"]
        solr_doc["unit_name_tesim"].should == ["Library Collections"]
      end
      it "should index collection" do
        solr_doc = subject.to_solr
        solr_doc["collection_1_id_tesim"].should == ["bb03030303"]
        solr_doc["collection_1_name_tesim"].should == ["UCSD Electronic Theses and Dissertations"]
        #solr_doc["collection_2_id_tesim"].should == ["bb24242424"]
        #solr_doc["collection_2_name_tesim"].should == ["Historical Dissertations"]
      end
    end
  end
  
  describe "::Date" do
    it "should have an rdf_type" do
      DamsObjectDatastream::Date.rdf_type.should == DAMS.Date
    end
  end
  
  describe "should store correct xml" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata') }
  
	  before do
	    subject.title = "Test Title"
	    subject.date = "2013"
	    #subject.subject = "Test subject"
	  end
	  it "should create a xml" do
	    xml =<<END
	   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Object rdf:about="http://library.ucsd.edu/ark:/20775/xx1111111x">
    <dams:date>
      <dams:Date>
        <rdf:value>2013</rdf:value>
      </dams:Date>
    </dams:date>
    <dams:title>
      <dams:Title>
        <rdf:value>Test Title</rdf:value>
      </dams:Title>
    </dams:title>
  </dams:Object>
</rdf:RDF>
END
	    subject.content.should be_equivalent_to xml
	
	  end
  end
  
    describe "an instance with content for new object model" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'bd6212468x', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectNewModel.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bd6212468x"
      end
      
      it "should have fields" do
        subject.title.should == ["Sample Object Record #8"]
        subject.subtitle.should == ["Name/Note/Subject Sampler"]
      end
      
      it "should index iconography" do
        testIndexFields "iconography","bd65537666","Madonna and Child","http://id.loc.gov/XXX03","XXX","Madonna and Child"     
      end      
      it "should index scientificName" do
        testIndexFields "scientificName","bd2662949r","Western lowland gorilla (Gorilla gorilla gorilla)","http://dbpedia.org/page/Western_lowland_gorilla","XXX","Western lowland gorilla (Gorilla gorilla gorilla)"
      end       
      it "should index technique" do
        testIndexFields "technique","bd8772217q","Impasto","http://id.loc.gov/XXX04","XXX","Impasto"
      end     
      it "should index occupation" do
        testIndexFields "occupation","bd72363644","Pharmacist","http://id.loc.gov/vocabulary/graphicMaterials/tgm007681","tgm","Pharmacist"
      end   
      it "should index builtWorkPlace" do
        testIndexFields "builtWorkPlace","bd1707307x","The Getty Center","http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994","CONA","The Getty Center"
      end    
      it "should index geographic" do
        testIndexFields "geographic","bd8533304b","Ness, Loch (Scotland)","http://id.loc.gov/authorities/sh85090955","lcsh","Ness, Loch (Scotland)"
      end   
      it "should index temporal" do
        testIndexFields "temporal","bd59394235","16th century","http://id.loc.gov/authorities/sh2002012470","lcsh","16th century"
      end 
      it "should index culturalContext" do
        testIndexFields "culturalContext","bd0410365x","Dutch","http://id.loc.gov/XXX01","XXX","Dutch"
      end   
      it "should index stylePeriod" do
        testIndexFields "stylePeriod","bd0069066b","Impressionism","http://id.loc.gov/XXX05","XXX","Impressionism"
      end    
      it "should index topic" do
        testIndexFields "topic","bd46424836","Baseball","http://id.loc.gov/authorities/subjects/sh85012026","lcsh","Baseball"
      end      
      it "should index function" do
        testIndexFields "function","bd7816576v","Sample Function","http://id.loc.gov/XXX02","XXX","Sample Function"
      end   
      it "should index genreForm" do
        testIndexFields "genreForm","bd9796116g","Film and video adaptions","http://id.loc.gov/authorities/sh2002012502","lcsh","Film and video adaptions"
      end 
      it "should index personalName" do
        testIndexNameFields "personalName","bd93182924","Burns, Jack O.","http://lccn.loc.gov/n90694888","naf","Burns","familyName"
      end        
      it "should index familyName" do
        testIndexNameFields "familyName","bd1775562z","Calder (Family : 1757-1959 : N.C.)","http://id.loc.gov/authorities/names/n2012026835","naf","Calder (Family :","familyName"
      end     
      it "should index name" do
        testIndexNameFields "name","bd7509406v","Generic Name","http://id.loc.gov/n9999999999","naf","Generic Name","name"
      end   
      it "should index conferenceName" do
        testIndexNameFields "conferenceName","bd0478622c","American Library Association. Annual Conference","http://id.loc.gov/authorities/names/n2009036967","naf","American Library Association.","name"
      end      
      it "should index corporateName" do
        testIndexNameFields "corporateName","bd8021352s","Lawrence Livermore Laboratory","http://lccn.loc.gov/n50000352","naf","Lawrence Livermore Laboratory","name"
      end    
      it "should index complexSubject" do
        testComplexSubjectFields "complexSubject","bd6724414c","Galaxies--Clusters","http://id.loc.gov/authorities/subjects/sh85052764","lcsh","Galaxies","Clusters"
      end                        
      it "should have scopeContentNote" do
		testIndexNoteFields "scopeContentNote","bd1366006j","scope_and_content","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.","Scope and contents"
      end   
      it "should have preferredCitationNote" do
		testIndexNoteFields "preferredCitationNote","bd3959888k","citation","\"Data at Redshift=1.4 (RD0022).\"  From: Rick Wagner, Eric J. Hallman, Brian W. O'Shea, Jack O. Burns, Michael L. Norman, Robert Harkness, and Geoffrey So.  \"The Santa Fe Light Cone Simulation research project files.\"  UC San Diego Research Cyberinfrastructure Data Curation. (Data version 1.0, published 2013; http://dx.doi.org/10.5060/&&&&&&&&)","Citation"
      end    
      it "should have CustodialResponsibilityNote" do
		testIndexNoteFields "custodialResponsibilityNote","bd9113515d","custodial_history","Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://libraries.ucsd.edu/locations/mscl/)","Digital object made available by"
      end    
      it "should have note" do
		testIndexNoteFields "note","bd52568274","abstract","This is some text to describe the basic contents of the object.","Abstract"
      end                              
      def testIndexFields (fieldName,id,name,valueURI,authority,element) 
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        solr_doc["#{fieldName}_1_valueURI_tesim"].should == ["#{valueURI}"]
        solr_doc["#{fieldName}_1_authority_tesim"].should == ["#{authority}"]
        #solr_doc["#{fieldName}_element_1_0_tesim"].should == ["#{element}"]
        solr_doc["#{fieldName}_1_0_#{fieldName}_tesim"].should == ["#{element}"]
      end    
      def testIndexNameFields (fieldName,id,name,valueURI,authority,element,elementName) 
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        solr_doc["#{fieldName}_1_valueURI_tesim"].should == ["#{valueURI}"]
        solr_doc["#{fieldName}_1_authority_tesim"].should == ["#{authority}"]
        #solr_doc["#{fieldName}_element_1_0_tesim"].should == ["#{element}"]
        solr_doc["#{fieldName}_1_0_#{elementName}_tesim"].should == ["#{element}"]
      end        
      def testIndexNoteFields (fieldName,id,type,value,displayLabel) 
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        solr_doc["#{fieldName}_1_type_tesim"].should == ["#{type}"]
        solr_doc["#{fieldName}_1_value_tesim"].should == ["#{value}"]
        solr_doc["#{fieldName}_1_displayLabel_tesim"].should == ["#{displayLabel}"]
      end       
      def testComplexSubjectFields (fieldName,id,name,valueURI,authority,topic0,topic1) 
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        solr_doc["#{fieldName}_1_valueURI_tesim"].should == ["#{valueURI}"]
        solr_doc["#{fieldName}_1_authority_tesim"].should == ["#{authority}"]
        solr_doc["#{fieldName}_1_0_topic_tesim"].should == ["#{topic0}"]
        solr_doc["#{fieldName}_1_1_topic_tesim"].should == ["#{topic1}"]
      end                                         
   end  
  
end
