# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsObjectDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx1111111x"
      end

    end

    describe "an instance with content" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx1111111x"
      end

      it "should have fields" do
        subject.typeOfResource.should == ["text"]
        subject.titleValue.should == "Chicano and black radical activism of the 1960s"
      end

      it "should have collection" do
        #subject.collection.first.scopeContentNote.first.displayLabel == ["Scope and contents"]
        subject.collection.first.to_s.should ==  "#{Rails.configuration.id_namespace}bbXXXXXXX3"
      end

      it "should have inline subjects" do
        subject.subject[0].name.should == ["Black Panther Party--History"]
        subject.subject[1].name.should == ["African Americans--Relations with Mexican Americans--History--20th Century"]
      end
      it "should have external subjects" do
        subject.subject[0].should_not be_external
        subject.subject[1].should_not be_external
        subject.subject[2].should be_external
      end

      it "should have relationship" do
        subject.relationship[0].name.first.pid.should == "bbXXXXXXX1"
        subject.relationship[0].role.first.pid.should == "bd55639754"        
      end

      it "should have date" do
        subject.dateValue.should == ["2010"]
      end

      it "should create a solr document" do
        MadsComplexSubject.should_receive(:find).with('bbXXXXXXX5').and_return(stub(:name =>'stubbed'))
        #stub_person = stub(:name => "Maria")
        #DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century","stubbed"]
        solr_doc["title_tesim"].should include "Chicano and black radical activism of the 1960s: a comparison between the Brown Berets and the Black Panther Party in California"
        solr_doc["date_tesim"].should include "2010"
        solr_doc["name_tesim"].should include "Yañez, Angélica María"
      end

    end

    describe "a complex object with flat component list" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'bb80808080', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb80808080"
      end
      it "should have a repeated date" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "2013"
        solr_doc["date_tesim"].should include "2012"
      end
      it "should have fields" do
        subject.typeOfResource.should == ["mixed material"]
        subject.titleValue.should == "Sample Complex Object Record #1"
        subject.subtitle.should == "a dissertation with a single attached image"
        subject.relatedResource.first.type.should == ["online exhibit"]
        subject.relatedResource.first.uri.should == ["http://foo.com/1234"]
        subject.relatedResource.first.description.should == ["Sample Complex Object Record #1: The Exhibit!"]
      end

	  it "should have repeated title" do
	  	solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Sample Complex Object Record #1: a dissertation with a single attached image"
        solr_doc["title_tesim"].should include "Other Title #2: Subtitle #2"
	  end
	
      it "should have inline subjects" do
        subject.subject.first.name.should == ["Black Panther Party--History"]
      end

      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bbXXXXXXX1"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should == ["Yañez, Angélica María"]
      end

      it "should have a first component with basic metadata" do
        subject.component.first.title.first.value.should == "The Static Image"
        subject.component.first.title.first.subtitle.should == "Foo!"
        subject.component.first.date.first.value.should == ["June 24-25, 2012"]
        subject.component.first.date.first.beginDate.should == ["2012-06-24"]
        subject.component.first.date.first.endDate.should == ["2012-06-25"]
        subject.component.first.note.first.value.should == ["1 PDF (xi, 111 p.)"]
        subject.component.first.note.first.displayLabel.should == ["Extent"]
        subject.component.first.note.first.type.should == ["dimensions"]
      end
      it "should have a first component with two attached files" do
        subject.component.first.file[0].rdf_subject.should == "#{Rails.configuration.id_namespace}bb80808080/1/1.pdf"
        subject.component.first.file[1].rdf_subject.should == "#{Rails.configuration.id_namespace}bb80808080/1/2.jpg"
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
        solr_doc["title_tesim"].should include "The Static Image: Foo!"
        solr_doc["title_tesim"].should include "The Static Image #2: Foo! #2"
        solr_doc["title_tesim"].should include "The Static Image #3: Foo! #3"
      end
	  it "should have a second component with repeating title" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Supplementary Image"
        solr_doc["title_tesim"].should include "Supplementary Image #2"
      end
	  it "should have a first component with repeating date" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "June 24-25, 2012"
        solr_doc["date_tesim"].should include "2012-06-24"
        solr_doc["date_tesim"].should include "2012-06-25"
        solr_doc["date_tesim"].should include "June 24-25, 2012 #2"
        solr_doc["date_tesim"].should include "2012-06-24 #2"
        solr_doc["date_tesim"].should include "2012-06-25 #2"
      end
	  it "should have a second component with repeating date" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "May 24, 2012"
        solr_doc["date_tesim"].should include "2012-05-24"
        solr_doc["date_tesim"].should include "2012-05-24"
        solr_doc["date_tesim"].should include "May 24, 2012 #2"
        solr_doc["date_tesim"].should include "2012-05-24 #2"
        solr_doc["date_tesim"].should include "2012-05-24 #2"
      end
      it "should index component metadata" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "The Static Image: Foo!"
        solr_doc["title_tesim"].should include "Supplementary Image"
      end
	  it "should index component topics at component and object level" do
        solr_doc = subject.to_solr
        solr_doc["subject_topic_sim"].should include "Subject 1"
        solr_doc["subject_topic_sim"].should include "Topic 2--Topic 3"
        solr_doc["component_1_subject_topic_sim"].should include "Subject 1"
        solr_doc["component_1_subject_topic_sim"].should include "Topic 2--Topic 3"
      end
      it "should index repeating linked metadata" do
        solr_doc = subject.to_solr
        solr_doc["language_tesim"].should == ["English"]

        # rights holder
        solr_doc["rightsHolder_tesim"].should == ["Administrator, Bob, 1977-"]
      end
      it "should index source capture" do
        solr_doc = subject.to_solr
        solr_doc["component_1_files_tesim"].first.should include '"source_capture":"bb49494949"'
        solr_doc["component_1_files_tesim"].first.should include '"scanner_manufacturer":"Epson"'
        solr_doc["component_1_files_tesim"].first.should include '"source_type":"transmission scanner"'
        solr_doc["component_1_files_tesim"].first.should include '"scanner_model_name":"Expression 1600"'
        solr_doc["component_1_files_tesim"].first.should include '"image_producer":"Luna Imaging, Inc."'
        solr_doc["component_1_files_tesim"].first.should include '"scanning_software_version":"2.10E"'
        solr_doc["component_1_files_tesim"].first.should include '"scanning_software":"Epson Twain Pro"'
        solr_doc["component_1_files_tesim"].first.should include '"capture_source":"B&W negative , 2 1/2 x 2 1/2"'
      end
      it "should index rights metadata" do
        solr_doc = subject.to_solr

        # copyright
        solr_doc["copyright_tesim"].first.should include '"id":"bb05050505"'
        solr_doc["copyright_tesim"].first.should include '"status":"Under copyright"'
        solr_doc["copyright_tesim"].first.should include '"jurisdiction":"us"'
        solr_doc["copyright_tesim"].first.should include '"note":"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."'
        solr_doc["copyright_tesim"].first.should include '"purposeNote":"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."'
        solr_doc["copyright_tesim"].first.should include '"beginDate":"1993-12-31"'

        # license
        solr_doc["license_tesim"].first.should include '"id":"bb22222222"'
        solr_doc["license_tesim"].first.should include '"note":"License note text here..."'
        solr_doc["license_tesim"].first.should include '"uri":"http://library.ucsd.edu/licenses/lic12341.pdf"'
        solr_doc["license_tesim"].first.should include '"permissionType":"display"'
        solr_doc["license_tesim"].first.should include '"permissionBeginDate":"2010-01-01"'

        # statute
        solr_doc["statute_tesim"].first.should include '"id":"bb21212121"'
        solr_doc["statute_tesim"].first.should include '"citation":"Family Education Rights and Privacy Act (FERPA)"'
        solr_doc["statute_tesim"].first.should include '"jurisdiction":"us"'
        solr_doc["statute_tesim"].first.should include '"note":"Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances."'
        solr_doc["statute_tesim"].first.should include '"restrictionType":"display"'
        solr_doc["statute_tesim"].first.should include '"restrictionBeginDate":"1974-08-21"'

        # other rights
        solr_doc["otherRights_tesim"].first.should include '"id":"bb06060606"'
        solr_doc["otherRights_tesim"].first.should include '"basis":"fair use"'
        solr_doc["otherRights_tesim"].first.should include '"uri":"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf"'
        solr_doc["otherRights_tesim"].first.should include '"permissionType":"display"'
        solr_doc["otherRights_tesim"].first.should include '"permissionBeginDate":"2011-09-24"'
        solr_doc["otherRights_tesim"].first.should include "\"name\":\"#{Rails.configuration.id_namespace}bb09090909\""
        solr_doc["otherRights_tesim"].first.should include "\"role\":\"#{Rails.configuration.id_namespace}bd3004227d\""
      end
      it "should index unit" do
        solr_doc = subject.to_solr
        solr_doc["unit_json_tesim"].first.should include "Library Digital Collections"
      end
      it "should index collection" do
        solr_doc = subject.to_solr
        #puts "solr: #{solr_doc.inspect}"
        solr_doc["collection_json_tesim"].join(" ").should include "UCSD Electronic Theses and Dissertations"
        solr_doc["collection_json_tesim"].join(" ").should include "May 2009"
      end
#      it "should have event" do
#        solr_doc = subject.to_solr
#        solr_doc["event_1_type_tesim"].should == ["object creation"]
#        solr_doc["event_1_eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
#        solr_doc["event_1_outcome_tesim"].should == ["success"]
#        solr_doc["event_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
#        solr_doc["event_1_role_tesim"].should == ["Initiator"]
#      end
    end
  end

  describe "Date" do
    it "should have an rdf_type" do
      DamsDate.rdf_type.should == DAMS.Date
    end
  end

  describe "should store correct xml" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'xx1111111x', :new? =>true), 'descMetadata') }

	  before do
	    subject.titleValue = "Test Title"
	    subject.title.first.name = "Test Title"
	    subject.dateValue = "2013"
	    #subject.subject = "Test subject"
	  end
	  it "should create a xml" do
	    xml =<<END
	   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dams="http://library.ucsd.edu/ontology/dams#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <dams:Object rdf:about="#{Rails.configuration.id_namespace}xx1111111x">
    <dams:date>
      <dams:Date>
        <rdf:value>2013</rdf:value>
      </dams:Date>
    </dams:date>
    <dams:title>
<mads:Title>
  <mads:authoritativeLabel>Test Title</mads:authoritativeLabel>
  <mads:elementList rdf:parseType="Collection">
    <mads:MainTitleElement>
      <mads:elementValue>Test Title</mads:elementValue>
    </mads:MainTitleElement>
  </mads:elementList>
</mads:Title>
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
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd6212468x"
      end

      it "should have fields" do
        subject.titleValue.should == "Sample Object Record #8"
        subject.subtitle.should == "Name/Note/Subject Sampler"
      end
      
      it "should index mads fields" do
        solr_doc = subject.to_solr
		
        #it "should index iconography" do
        testIndexFields solr_doc, "iconography","Madonna and Child"

        #it "should index scientificName" do
        testIndexFields solr_doc, "scientificName","Western lowland gorilla (Gorilla gorilla gorilla)"

        #it "should index technique" do
        testIndexFields solr_doc, "technique","Impasto"

        #it "should index occupation" do
        testIndexFields solr_doc, "occupation","Pharmacist"

        #it "should index builtWorkPlace" do
        testIndexFields solr_doc, "builtWorkPlace","The Getty Center"

        #it "should index geographic" do
        testIndexFields solr_doc, "geographic","Ness, Loch (Scotland)"

        #it "should index temporal" do
        testIndexFields solr_doc, "temporal","16th century"

        #it "should index culturalContext" do
        testIndexFields solr_doc, "culturalContext","Dutch"

        #it "should index stylePeriod" do
        testIndexFields solr_doc, "stylePeriod","Impressionism"

        #it "should index topic" do
        solr_doc["topic_tesim"].should == ["Baseball", "Marine sediments"]

        #it "should index function" do
        solr_doc["function_tesim"].should == ["Sample Function", "internal function value"]

        #it "should index genreForm" do
        testIndexFields solr_doc, "genreForm","Film and video adaptions"

        #it "should index personalName" do
        solr_doc["personalName_tesim"].should == ["Burns, Jack O.", "Burns, Jack O.....", "Burns, Jack O.....2"]

        #it "should index familyName" do
        solr_doc["familyName_tesim"].should == ["Calder (Family : 1757-1959 : N.C.)", "Calder (Family : 1757-1959 : N.C.)...."]

        #it "should index name" do
        solr_doc["name_tesim"].should == ["Scripps Institute of Oceanography, Geological Collections", "Yañez, Angélica María", "Personal Name 2", "Name 4", "Generic Name", "Generic Name Internal"]

        #it "should index conferenceName" do
        solr_doc["conferenceName_tesim"].should == ["American Library Association. Annual Conference", "American Library Association. Annual Conference...."]

        #it "should index corporateName" do
        solr_doc["corporateName_tesim"].should == ["Lawrence Livermore Laboratory", "Lawrence Livermore Laboratory......"]

        #it "should index complexSubject" do
        testComplexSubjectFields solr_doc, "complexSubject","Galaxies--Clusters"

        #it "should index subjects" do
        solr_doc["subject_tesim"].should == ["Black Panther Party--History", "Academic dissertations"]
        
        #it "should have scopeContentNote" do
        solr_doc["scopeContentNote_tesim"].should == ["Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.","scope content note internal value"]        

        #it "should have preferredCitationNote" do
        solr_doc["preferredCitationNote_tesim"].should == ["Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.", "citation note internal value"]                

        #it "should have CustodialResponsibilityNote" do
        solr_doc["custodialResponsibilityNote_tesim"].should == ["Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.", "Mandeville Special Collections Library....Internal value"]

        #it "should have note" do
		testIndexNoteFields solr_doc, "note","Note internal value."
		
		solr_doc["copyright_tesim"].first.should include "Under copyright -- 3rd Party"
		
		solr_doc["rightsHolder_tesim"].should == ["Administrator, Bob, 1977- internal", "Administrator, Bob, 1977-", "UC Regents"]
		
		#internal license
        solr_doc["license_tesim"].first.should include '"id":"zz22222222"'
        solr_doc["license_tesim"].first.should include '"note":"License note text here..."'
        solr_doc["license_tesim"].first.should include '"uri":"http://library.ucsd.edu/licenses/lic12341.pdf"'
        solr_doc["license_tesim"].first.should include '"permissionType":"display"'
        solr_doc["license_tesim"].first.should include '"permissionBeginDate":"2010-01-01"'		
        
		# other rights
        solr_doc["otherRights_tesim"].first.should include '"id":"zz06060606"'
        solr_doc["otherRights_tesim"].first.should include '"basis":"fair use"'
        solr_doc["otherRights_tesim"].first.should include '"uri":"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf"'
        solr_doc["otherRights_tesim"].first.should include '"permissionType":"display"'
        solr_doc["otherRights_tesim"].first.should include '"permissionBeginDate":"2011-09-24"'
        solr_doc["otherRights_tesim"].first.should include "\"name\":\"#{Rails.configuration.id_namespace}bb09090909\""
        solr_doc["otherRights_tesim"].first.should include "\"role\":\"#{Rails.configuration.id_namespace}bd3004227d\""
        
        # statute
        solr_doc["statute_tesim"].first.should include '"id":"zz21212121"'
        solr_doc["statute_tesim"].first.should include '"citation":"Family Education Rights and Privacy Act (FERPA)"'
        solr_doc["statute_tesim"].first.should include '"jurisdiction":"us"'
        solr_doc["statute_tesim"].first.should include '"note":"Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances."'
        solr_doc["statute_tesim"].first.should include '"restrictionType":"display"'
        solr_doc["statute_tesim"].first.should include '"restrictionBeginDate":"1974-08-21"'      
        
        solr_doc["cartographics_json_tesim"].first.should include "1:20000" 
        
        solr_doc["event_json_tesim"].first.should include '"pid":"bb07070707","type":"object creation"' 
        solr_doc["event_json_tesim"][1].should include '"pid":"zz07070707","type":"object creation inline event"' 
        solr_doc["event_json_tesim"][2].should include '"name":"dams:unknownUser","role":"dams:initiator"'
        
        solr_doc["unit_json_tesim"].first.should include '"id":"bb48484848","code":"rci","name":"Research Data Curation Program"'
        
        solr_doc["title_json_tesim"].first.should include '"nonSort":"The","partName":"sample partname","partNumber":"sample partnumber"'
                
      end

	  it "should index relationship" do
	  	solr_doc = subject.to_solr
	  	solr_doc["relationship_json_tesim"].first.should include '"Repository":["Name 4","Personal Name 2","Scripps Institute of Oceanography, Geological Collections"]'
	  end
	  
      it "should index collection" do
        solr_doc = subject.to_solr
        solr_doc["collection_json_tesim"].join(" ").should include "UCSD Electronic Theses and Dissertations"
        solr_doc["collection_json_tesim"].join(" ").should include "Scripps Institution of Oceanography, Geological Collections"
        solr_doc["collection_json_tesim"].join(" ").should include "May 2009"
      end
      
      def testIndexFields (solr_doc,fieldName,name)
        solr_doc["#{fieldName}_tesim"].should == ["#{name}"]
        #solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        #solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        #solr_doc["#{fieldName}_1_externalAuthority_tesim"].should == ["#{externalAuthority}"]
        #solr_doc["#{fieldName}_1_scheme_tesim"].should == ["#{scheme}"]
        #solr_doc["#{fieldName}_element_1_0_tesim"].should == ["#{element}"]
        #solr_doc["#{fieldName}_1_0_#{fieldName}_tesim"].should == ["#{element}"]
      end
      def testIndexNameFields (solr_doc,fieldName,name)
        solr_doc["#{fieldName}_tesim"].should == ["#{name}"]
        #solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        #solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        #solr_doc["#{fieldName}_1_externalAuthority_tesim"].should == ["#{externalAuthority}"]
        #solr_doc["#{fieldName}_1_scheme_tesim"].should == ["#{scheme}"]
        #solr_doc["#{fieldName}_element_1_0_tesim"].should == ["#{element}"]
        #solr_doc["#{fieldName}_1_0_#{elementName}_tesim"].should == ["#{element}"]
      end
      def testIndexNoteFields (solr_doc,fieldName,value)
        solr_doc["#{fieldName}_tesim"].should include value
        #solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        #solr_doc["#{fieldName}_1_type_tesim"].should == ["#{type}"]
        #solr_doc["#{fieldName}_1_value_tesim"].should == ["#{value}"]
        #solr_doc["#{fieldName}_1_displayLabel_tesim"].should == ["#{displayLabel}"]
      end
      def testComplexSubjectFields (solr_doc,fieldName,name)
        solr_doc["#{fieldName}_tesim"].should include name
        #solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        #solr_doc["#{fieldName}_1_name_tesim"].should == ["#{name}"]
        #solr_doc["#{fieldName}_1_externalAuthority_tesim"].should == ["#{externalAuthority}"]
        #solr_doc["#{fieldName}_1_scheme_tesim"].should == ["#{scheme}"]
        #solr_doc["#{fieldName}_1_0_topic_tesim"].should == ["#{topic0}"]
        #solr_doc["#{fieldName}_1_1_topic_tesim"].should == ["#{topic1}"]
      end
   end

    describe "a complex object with internal classes" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'bd0171551x', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectInternal.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd0171551x"
      end
      it "should have a repeated date" do
        solr_doc = subject.to_solr
        solr_doc["title_json_tesim"].first.should include "RNDB11WT-74P (core, piston)"
        solr_doc["collection_json_tesim"].first.should include '"id":"bd24241158","name":"Scripps Institution of Oceanography, Geological Collections","type":"ProvenanceCollection"'     
		solr_doc["relationship_json_tesim"].first.should include '"Collector":["ROUNDABOUT--11","Thomas Washington"]'
		#puts solr_doc["relationship_json_tesim"]
		#puts solr_doc["unit_tesim"]
      end
    end
end
