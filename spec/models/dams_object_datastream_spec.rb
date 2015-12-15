# -*- encoding: utf-8 -*-

require 'spec_helper'

describe DamsObjectDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx1111111x"
      end

    end

    describe "an instance with content" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      before(:all) do
        @role = MadsAuthority.create pid: 'bd55639754', name: 'Creator', code: 'cre'
        @name = MadsPersonalName.create pid: 'xxXXXXXXX1', name: "Yañez, Angélica María"
      end
      after(:all) do
        @role.delete
        @name.delete
        @copy = DamsCopyright.find('xx15151515')
        @copy.delete
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
        subject.collection.first.to_s.should ==  "#{Rails.configuration.id_namespace}xxXXXXXXX3"
      end

      it "should have inline subjects" do
        actual = []
        subject.complexSubject.each do |s|
          actual << s.name.first
        end
        actual.should include "Black Panther Party--History"
        actual.should include "Academic dissertations"
      end
      it "should have external subjects" do
        subject.complexSubject[0].should_not be_external
        subject.complexSubject[1].should be_external
        subject.complexSubject[2].should_not be_external
      end

      it "should have relationship" do
        subject.relationship[0].name.first.pid.should == "xxXXXXXXX2"
        subject.relationship[0].role.first.pid.should == "bd55639754"        
      end

      it "should have date" do
        subject.dateValue.should == ["2010"]
      end

    end

    describe "a complex object with flat component list" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'xx80808080', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
        subject
      end
      before(:all) do
        @role1 = MadsAuthority.create pid: 'bd55639754', name: 'Creator'
        @role2 = MadsAuthority.create pid: 'bd3004227d', name: 'Decision Maker'
        @name = MadsPersonalName.create pid: 'xx09090909', name: 'Administrator, Bob, 1977-'
        @other = DamsOtherRight.create pid: 'xx06060606', basis: 'fair use', uri:"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf", permissionType: 'display', permissionBeginDate: '2011-09-24', name:['xx09090909'], role:['bd3004227d']

      end
      after(:all) do
        @name.delete
        @role1.delete
        @role2.delete
        @other.delete
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx80808080"
      end
      it "should have a repeated date" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "1980-05-20"
        solr_doc["date_tesim"].should include "1980-05-24"
        solr_doc["decade_sim"].should include "1980s"
      end
      it "should have fields" do
        subject.typeOfResource.should == ["mixed material"]
        subject.titleValue.should == "Sample Complex Object Record #1"
        subject.subtitle.should == "a newspaper PDF with a single attached image"
        subject.relatedResource.first.type.should == ["online exhibit"]
        subject.relatedResource.first.uri.should == ["http://foo.com/1234"]
        subject.relatedResource.first.description.should == ["Sample Complex Object Record #1: The Exhibit!"]
      end

	  it "should have title" do
	  	solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Sample Complex Object Record #1: a newspaper PDF with a single attached image"
	  end
	
      it "should have relationship" do
        subject.relationship.first.personalName.first.pid.should == "xxXXXXXXX1"
        subject.relationship.first.role.first.pid.should == "bd55639754"
      end

      it "should have a first component with basic metadata" do
        subject.component.first.title.first.value.should == "The Daily Guardian"
        subject.component.first.date.first.value.should == ["Tuesday, May 20, 1980"]
        subject.component.first.date.first.beginDate.should == ["1980-05-20"]
        subject.component.first.date.first.endDate.should == ["1980-05-20"]
        subject.component.first.note.first.value.should == ["1 PDF (8 p.)"]
        subject.component.first.note.first.displayLabel.should == ["Extent"]
        subject.component.first.note.first.type.should == ["dimensions"]
      end
      it "should create a solr document" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Sample Complex Object Record #1: a newspaper PDF with a single attached image"
        solr_doc["date_tesim"].should include "1980-05-24"
        solr_doc["language_tesim"].should include "English"
        solr_doc["note_tesim"].should include "Dissertation is in English."
        solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/xx80808080"
        solr_doc["note_tesim"].should include "b6700311"
        solr_doc["note_tesim"].should include "1 PDF (8 p.)"
        solr_doc["related_resource_json_tesim"].to_s.should include "online exhibit"
        solr_doc["related_resource_json_tesim"].to_s.should include "Sample Complex Object Record #1: The Exhibit!"
        solr_doc["object_type_sim"].should include "text"
        solr_doc["object_type_sim"].should include "image"
        solr_doc["object_type_sim"].should include "mixed material"

      end

      it "should have a first component with two attached files" do
        subject.component.first.file[0].rdf_subject.should == "#{Rails.configuration.id_namespace}xx80808080/1/1.pdf"
        subject.component.first.file[1].rdf_subject.should == "#{Rails.configuration.id_namespace}xx80808080/1/2.jpg"
      end
	  it "should have a first component with repeating title" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Supplementary Image"
        solr_doc["title_tesim"].should include "Supplementary Image Foo"
      end
	  it "should have a second component" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should include "Part 2 of 2"
      end
	  it "should have a dates" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "Tuesday, May 20, 1980"
        solr_doc["date_tesim"].should include "May 24, 1980"
        solr_doc["date_tesim"].should include "1980-05-20"
        solr_doc["date_tesim"].should include "1980-05-24"
      end
      it "should index repeating linked metadata" do
        solr_doc = subject.to_solr
        solr_doc["language_tesim"].should == ["English"]

        # rights holder
        solr_doc["rightsHolder_tesim"].should == ["Administrator, Bob, 1977-"]
      end
      it "should index source capture" do
        solr_doc = subject.to_solr
        solr_doc["component_1_files_tesim"].first.should include '"source_capture":"xx49494949"'
        solr_doc["component_1_files_tesim"].first.should include '"scanner_manufacturer":"Epson"'
        solr_doc["component_1_files_tesim"].first.should include '"source_type":"transmission scanner"'
        solr_doc["component_1_files_tesim"].first.should include '"scanner_model_name":"Expression 1600"'
        solr_doc["component_1_files_tesim"].first.should include '"image_producer":"Luna Imaging, Inc."'
        solr_doc["component_1_files_tesim"].first.should include '"scanning_software_version":"2.10E"'
        solr_doc["component_1_files_tesim"].first.should include '"scanning_software":"Epson Twain Pro"'
        solr_doc["component_1_files_tesim"].first.should include '"capture_source":"B\\u0026W negative , 2 1/2 x 2 1/2"'
      end
      it "should index rights metadata" do
        solr_doc = subject.to_solr

        # copyright
        solr_doc["copyright_tesim"].first.should include '"status":"Under copyright"'
        solr_doc["copyright_tesim"].first.should include '"jurisdiction":"us"'
        solr_doc["copyright_tesim"].first.should include '"note":"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."'
        solr_doc["copyright_tesim"].first.should include '"purposeNote":"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."'
        solr_doc["copyright_tesim"].first.should include '"beginDate":"1993-12-31"'

        # license
        solr_doc["license_tesim"].first.should include '"id":"xx22222222"'
        solr_doc["license_tesim"].first.should include '"note":"License note text here..."'
        solr_doc["license_tesim"].first.should include '"uri":"http://library.ucsd.edu/licenses/lic12341.pdf"'
        solr_doc["license_tesim"].first.should include '"permissionType":"display"'
        solr_doc["license_tesim"].first.should include '"permissionBeginDate":"2010-01-01"'

        # statute
        solr_doc["statute_tesim"].first.should include '"id":"xx21212121"'
        solr_doc["statute_tesim"].first.should include '"citation":"Family Education Rights and Privacy Act (FERPA)"'
        solr_doc["statute_tesim"].first.should include '"jurisdiction":"us"'
        solr_doc["statute_tesim"].first.should include '"note":"Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances."'
        solr_doc["statute_tesim"].first.should include '"restrictionType":"display"'
        solr_doc["statute_tesim"].first.should include '"restrictionBeginDate":"1974-08-21"'

        # other rights
        solr_doc["otherRights_tesim"].first.should include '"id":"xx06060606"'
        solr_doc["otherRights_tesim"].first.should include '"basis":"fair use"'
        solr_doc["otherRights_tesim"].first.should include '"uri":"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf"'
        solr_doc["otherRights_tesim"].first.should include '"permissionType":"display"'
        solr_doc["otherRights_tesim"].first.should include '"permissionBeginDate":"2011-09-24"'
        solr_doc["otherRights_tesim"].first.should include "\"name\":\"#{Rails.configuration.id_namespace}xx09090909\""
        solr_doc["otherRights_tesim"].first.should include "\"role\":\"#{Rails.configuration.id_namespace}bd3004227d\""
      end
      it "should index unit" do
        solr_doc = subject.to_solr
        solr_doc["unit_json_tesim"].first.should include "Library Digital Collections"
      end
      it "should index collection" do
        solr_doc = subject.to_solr
        solr_doc["collection_json_tesim"].join(" ").should include "UCSD Electronic Theses and Dissertations"
      end
#      it "should have event" do
#        solr_doc = subject.to_solr
#        solr_doc["event_1_type_tesim"].should == ["record created"]
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
      subject { DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata') }

	  before do
	    subject.titleValue = "Test Title"
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
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'bd6212468x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectNewModel.xml').read
        subject
      end
      before(:all) do
        @subj = MadsComplexSubject.create pid: 'zz44444444', name: 'Test linked subject--More test'
        @role = MadsAuthority.create pid: 'bd3004227d', name: 'Decision Maker'
        @name = MadsPersonalName.create pid: 'xx09090909', name: 'Administrator, Bob, 1977-'
        @other = DamsOtherRight.create pid: 'zz06060606', basis: 'fair use', uri:"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf", permissionType: 'display', permissionBeginDate: '2011-09-24', name:['xx09090909'], role:['bd3004227d']
        @statute = DamsStatute.create pid: 'zz21212121', citation:"Family Education Rights and Privacy Act (FERPA)", jurisdiction:"us", note:"Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances.", restrictionType:"display", restrictionBeginDate:"1974-08-21"
      end
      after(:all) do
        @subj.delete
        @other.delete
        @name.delete
        @role.delete
        @statute.delete
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd6212468x"
      end

      it "should have fields" do
        subject.titleValue.should == "Sample Object Record #8"
        subject.subtitle.should == "Name/Note/Subject Sampler"
        subject.titleVariant.should == ["The Whale 2", "The Whale"]
        subject.titleTranslationVariant.should == ["Translation Variant 2", "Translation Variant"]
	    subject.titleAbbreviationVariant.should == ["Abbreviation Variant 2", "Abbreviation Variant"]
	    subject.titleAcronymVariant.should == ["Acronym Variant 2", "Acronym Variant"]
	    subject.titleExpansionVariant.should == ["Expansion Variant 2", "Expansion Variant"]
      end
      
      it "should index metadata" do
        solr_doc = subject.to_solr
		
        #it "should index iconography" do
        solr_doc["iconography_tesim"].should == ["Madonna and Child"]

        #it "should index lithology" do
        solr_doc["lithology_tesim"].should == ["test lithology"]
        
        #it "should index series" do
        solr_doc["series_tesim"].should == ["test series"]
        
        #it "should index cruise" do
        solr_doc["cruise_tesim"].should == ["test cruise"]
                        
        #it "should index technique" do
        solr_doc["technique_tesim"].should == ["Impasto"]

        #it "should index personalName" do
        solr_doc["personalName_tesim"].should include "Burns, Jack O....."
        solr_doc["personalName_tesim"].should include "Burns, Jack O.....2"
        
        #it "should index familyName" do
        solr_doc["familyName_tesim"].should include "Calder (Family : 1757-1959 : N.C.)...."

        #it "should index name" do        
        solr_doc["name_tesim"].should include "Scripps Institute of Oceanography, Geological Collections"
        solr_doc["name_tesim"].should include "Yañez, Angélica María"
        solr_doc["name_tesim"].should include "Personal Name 2"
        solr_doc["name_tesim"].should include "Name 4"
        solr_doc["name_tesim"].should include "Conference Name 2"
        solr_doc["name_tesim"].should include "Family Name 2"
        solr_doc["name_tesim"].should include "Generic Name Internal"
        solr_doc["name_tesim"].should include "American Library Association. Annual Conference...."
        solr_doc["name_tesim"].should include "Lawrence Livermore Laboratory......"
        solr_doc["name_tesim"].should include "Calder (Family : 1757-1959 : N.C.)...."
        solr_doc["name_tesim"].should include "Burns, Jack O....."
        solr_doc["name_tesim"].should include "Burns, Jack O.....2"

        #it "should index conferenceName" do
        solr_doc["conferenceName_tesim"].should == ["American Library Association. Annual Conference...."]

        #it "should index corporateName" do
        solr_doc["corporateName_tesim"].should == ["Lawrence Livermore Laboratory......"]

        #it "should index complexSubject" do
        solr_doc["complexSubject_tesim"].should include "Test linked subject--More test"
        
        #it "should have scopeContentNote" do
        solr_doc["scopeContentNote_tesim"].should == ["scope content note internal value"]        

        #it "should have preferredCitationNote" do
        solr_doc["preferredCitationNote_tesim"].should == ["citation note internal value"]                

        #it "should have CustodialResponsibilityNote" do
        solr_doc["custodialResponsibilityNote_tesim"].should == ["Mandeville Special Collections Library....Internal value"]

        #it "should have note" do
		solr_doc["note_tesim"].should include "Note internal value."
		
        solr_doc["rightsHolder_tesim"].should include "Administrator, Bob, 1977- internal"
        solr_doc["rightsHolder_tesim"].should include "UC Regents"
		
        solr_doc["cartographics_json_tesim"].first.should include "1:20000" 

        solr_doc["unit_json_tesim"].first.should include '"id":"xx48484848","code":"rdcp","name":"Research Data Curation Program"'
        
        # title and variant titles
        solr_doc["title_json_tesim"].first.should include '"nonSort":"The","partName":"sample partname","partNumber":"sample partnumber","subtitle":"Name/Note/Subject Sampler","variant":["The Whale 2","The Whale"],"translationVariant":["Translation Variant 2","Translation Variant"],"abbreviationVariant":["Abbreviation Variant 2","Abbreviation Variant"],"acronymVariant":["Acronym Variant 2","Acronym Variant"],"expansionVariant":["Expansion Variant 2","Expansion Variant"]'
        solr_doc["titleVariant_tesim"].should == ["The Whale 2", "The Whale"]
        solr_doc["titleTranslationVariant_tesim"].should == ["Translation Variant 2", "Translation Variant"]
        solr_doc["titleAbbreviationVariant_tesim"].should == ["Abbreviation Variant 2", "Abbreviation Variant"]
        solr_doc["titleAcronymVariant_tesim"].should == ["Acronym Variant 2", "Acronym Variant"]
        solr_doc["titleExpansionVariant_tesim"].should == ["Expansion Variant 2", "Expansion Variant"]

        # subject
        solr_doc["subject_topic_sim"].should include "Test linked subject--More test"
        solr_doc["subject_topic_sim"].should include "Madonna and Child"
        solr_doc["subject_topic_sim"].should include "Impasto"
        solr_doc["subject_topic_sim"].should include "Generic Name Internal"
        solr_doc["subject_topic_sim"].should include "American Library Association. Annual Conference...."
        solr_doc["subject_topic_sim"].should include "Lawrence Livermore Laboratory......"
        solr_doc["subject_topic_sim"].should include "Calder (Family : 1757-1959 : N.C.)...."
        solr_doc["subject_topic_sim"].should include "Burns, Jack O....."
        solr_doc["subject_topic_sim"].should include "Burns, Jack O.....2"

      end

      it "should index relationship" do
        solr_doc = subject.to_solr
        solr_doc["relationship_json_tesim"].first.should == '{"Repository":["Conference Name 2","Family Name 2","Name 4","Personal Name 2","Scripps Institute of Oceanography, Geological Collections"],"Creator":["Yañez, Angélica María"]}'
      end
	    
      it "should index collection" do
        solr_doc = subject.to_solr
        solr_doc["collection_json_tesim"].join(" ").should include "UCSD Electronic Theses and Dissertations"
        solr_doc["collection_json_tesim"].join(" ").should include "Scripps Institution of Oceanography, Geological Collections"
        solr_doc["collection_json_tesim"].join(" ").should include "May 2009"
      end
   end

    describe "a complex object with internal classes" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'bd0171551x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectInternal.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd0171551x"
      end
      it "should index title and collection" do
        solr_doc = subject.to_solr
        solr_doc["title_json_tesim"].first.should include "RNDB11WT-74P (core, piston)"
        solr_doc["collection_json_tesim"].first.should include '"id":"bd24241158","name":"Scripps Institution of Oceanography, Geological Collections","visibility":"public","type":"ProvenanceCollection"'     
		solr_doc["relationship_json_tesim"].first.should include '"Collector":["ROUNDABOUT--11","Thomas Washington"]'
      end
    end
    describe "a complex object with internal classes" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'bd0171551x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectComponentFileMetadata.rdf.xml').read
        subject
      end
      it "should have a component with a first file with file metadata" do
        subject.component.first.file.first.sourcePath.should == ["/pub/data1/dams_staging/rci/staging/siogeocoll/RNDB_RCI_Jan2013/data/XRF_Data"]
        subject.component.first.file.first.sourceFileName.should == ["rndb11wt-074P_A_600-748cm_xrfdata_50kV_001.XLS"]
        subject.component.first.file.first.formatName.should == ["bytestream"]
        subject.component.first.file.first.formatVersion.should == ["4.0"]
        subject.component.first.file.first.mimeType.should == ["application/octet-stream"]
        subject.component.first.file.first.use.should == ["data-service"]
        subject.component.first.file.first.size.should == ["212480"]
        subject.component.first.file.first.crc32checksum.should == ["66518753"]
        subject.component.first.file.first.md5checksum.should == ["688061e851f069bf52513210bd55eef3"]
        subject.component.first.file.first.sha1checksum.should == ["969e1d6125cec163afd22bb3ff0878e3e5e84695"]
        subject.component.first.file.first.dateCreated.should == ["2013-01-11T12:29:47-0800"]
        subject.component.first.file.first.objectCategory.should == ["file"]
        subject.component.first.file.first.compositionLevel.should == ["0"]
        subject.component.first.file.first.preservationLevel.should == ["full"]
      end
    end
  describe "Solr indexing" do
    subject do
      DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata')
    end
  end

  describe "sort date indexing" do
    subject { DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata') }
	before do
      subject.dateValue = "January 1-31, 1993"
      subject.beginDate = "1993-12-01"
	end
    it "should index a sort date" do
      # sort date
      solr_doc = subject.to_solr
      solr_doc["object_create_dtsi"].should == "1993-12-01T00:00:00Z"
    end
  end
end
