# -*- encoding: utf-8 -*-

require 'spec_helper'

describe DamsObjectDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsObjectDatastream.new(double('inner object', :pid=>'xx1111111x', :new_record? =>true), 'descMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx1111111x")
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
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx1111111x")
      end

      it "should have fields" do
        expect(subject.typeOfResource).to eq(["text"])
        expect(subject.titleValue).to eq("Chicano and black radical activism of the 1960s")
      end

      it "should have collection" do
        #subject.collection.first.scopeContentNote.first.displayLabel == ["Scope and contents"]
        expect(subject.collection.first.to_s).to eq("#{Rails.configuration.id_namespace}xxXXXXXXX3")
      end

      it "should have inline subjects" do
        actual = []
        subject.complexSubject.each do |s|
          actual << s.name.first
        end
        expect(actual).to include "Black Panther Party--History"
        expect(actual).to include "Academic dissertations"
      end
      it "should have external subjects" do
        expect(subject.complexSubject[0]).not_to be_external
        expect(subject.complexSubject[1]).to be_external
        expect(subject.complexSubject[2]).not_to be_external
      end

      it "should have relationship" do
        expect(subject.relationship[0].name.first.pid).to eq("xxXXXXXXX2")
        expect(subject.relationship[0].role.first.pid).to eq("bd55639754")        
      end

      it "should have date" do
        expect(subject.dateValue).to eq(["2010"])
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
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx80808080")
      end
      it "should have a repeated date" do
        solr_doc = subject.to_solr
        expect(solr_doc["date_tesim"]).to include "1980-05-20"
        expect(solr_doc["date_tesim"]).to include "1980-05-24"
        expect(solr_doc["decade_sim"]).to include "1980s"
      end
      it "should have fields" do
        expect(subject.typeOfResource).to eq(["mixed material"])
        expect(subject.titleValue).to eq("Sample Complex Object Record #1")
        expect(subject.subtitle).to eq("a newspaper PDF with a single attached image")
        expect(subject.relatedResource.first.type).to eq(["online exhibit"])
        expect(subject.relatedResource.first.uri).to eq(["http://foo.com/1234"])
        expect(subject.relatedResource.first.description).to eq(["Sample Complex Object Record #1: The Exhibit!"])
      end

	  it "should have title" do
	  	solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to include "Sample Complex Object Record #1: a newspaper PDF with a single attached image"
	  end
	
      it "should have relationship" do
        expect(subject.relationship.first.personalName.first.pid).to eq("xxXXXXXXX1")
        expect(subject.relationship.first.role.first.pid).to eq("bd55639754")
      end

      it "should have a first component with basic metadata" do
        expect(subject.component.first.title.first.value).to eq("The Daily Guardian")
        expect(subject.component.first.date.first.value).to eq(["Tuesday, May 20, 1980"])
        expect(subject.component.first.date.first.beginDate).to eq(["1980-05-20"])
        expect(subject.component.first.date.first.endDate).to eq(["1980-05-20"])
        expect(subject.component.first.note.first.value).to eq(["1 PDF (8 p.)"])
        expect(subject.component.first.note.first.displayLabel).to eq(["Extent"])
        expect(subject.component.first.note.first.type).to eq(["dimensions"])
      end
      it "should create a solr document" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to include "Sample Complex Object Record #1: a newspaper PDF with a single attached image"
        expect(solr_doc["date_tesim"]).to include "1980-05-24"
        expect(solr_doc["language_tesim"]).to include "English"
        expect(solr_doc["note_tesim"]).to include "Dissertation is in English."
        expect(solr_doc["note_tesim"]).to include "http://library.ucsd.edu/ark:/20775/xx80808080"
        expect(solr_doc["note_tesim"]).to include "b6700311"
        expect(solr_doc["note_tesim"]).to include "1 PDF (8 p.)"
        expect(solr_doc["related_resource_json_tesim"].to_s).to include "online exhibit"
        expect(solr_doc["related_resource_json_tesim"].to_s).to include "Sample Complex Object Record #1: The Exhibit!"
        expect(solr_doc["object_type_sim"]).to include "text"
        expect(solr_doc["object_type_sim"]).to include "image"
        expect(solr_doc["object_type_sim"]).to include "mixed material"

      end

      it "should have a first component with two attached files" do
        expect(subject.component.first.file[0].rdf_subject).to eq("#{Rails.configuration.id_namespace}xx80808080/1/1.pdf")
        expect(subject.component.first.file[1].rdf_subject).to eq("#{Rails.configuration.id_namespace}xx80808080/1/2.jpg")
      end
	  it "should have a first component with repeating title" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to include "Supplementary Image"
        expect(solr_doc["title_tesim"]).to include "Supplementary Image Foo"
      end
	  it "should have a second component" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to include "Part 2 of 2"
      end
	  it "should have a dates" do
        solr_doc = subject.to_solr
        expect(solr_doc["date_tesim"]).to include "Tuesday, May 20, 1980"
        expect(solr_doc["date_tesim"]).to include "May 24, 1980"
        expect(solr_doc["date_tesim"]).to include "1980-05-20"
        expect(solr_doc["date_tesim"]).to include "1980-05-24"
      end
      it "should index repeating linked metadata" do
        solr_doc = subject.to_solr
        expect(solr_doc["language_tesim"]).to eq(["English"])

        # rights holder
        expect(solr_doc["rightsHolder_tesim"]).to eq(["Administrator, Bob, 1977-"])
      end
      it "should index source capture" do
        solr_doc = subject.to_solr
        expect(solr_doc["component_1_files_tesim"].first).to include '"source_capture":"xx49494949"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"scanner_manufacturer":"Epson"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"source_type":"transmission scanner"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"scanner_model_name":"Expression 1600"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"image_producer":"Luna Imaging, Inc."'
        expect(solr_doc["component_1_files_tesim"].first).to include '"scanning_software_version":"2.10E"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"scanning_software":"Epson Twain Pro"'
        expect(solr_doc["component_1_files_tesim"].first).to include '"capture_source":"B\\u0026W negative , 2 1/2 x 2 1/2"'
      end
      it "should index rights metadata" do
        solr_doc = subject.to_solr

        # copyright
        expect(solr_doc["copyright_tesim"].first).to include '"status":"Under copyright"'
        expect(solr_doc["copyright_tesim"].first).to include '"jurisdiction":"us"'
        expect(solr_doc["copyright_tesim"].first).to include '"note":"This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."'
        expect(solr_doc["copyright_tesim"].first).to include '"purposeNote":"This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."'
        expect(solr_doc["copyright_tesim"].first).to include '"beginDate":"1993-12-31"'

        # license
        expect(solr_doc["license_tesim"].first).to include '"id":"xx22222222"'
        expect(solr_doc["license_tesim"].first).to include '"note":"License note text here..."'
        expect(solr_doc["license_tesim"].first).to include '"uri":"http://library.ucsd.edu/licenses/lic12341.pdf"'
        expect(solr_doc["license_tesim"].first).to include '"permissionType":"display"'
        expect(solr_doc["license_tesim"].first).to include '"permissionBeginDate":"2010-01-01"'

        # statute
        expect(solr_doc["statute_tesim"].first).to include '"id":"xx21212121"'
        expect(solr_doc["statute_tesim"].first).to include '"citation":"Family Education Rights and Privacy Act (FERPA)"'
        expect(solr_doc["statute_tesim"].first).to include '"jurisdiction":"us"'
        expect(solr_doc["statute_tesim"].first).to include '"note":"Prohibits disclosure of educational records containing personally-identifying information except in certain circumstances."'
        expect(solr_doc["statute_tesim"].first).to include '"restrictionType":"display"'
        expect(solr_doc["statute_tesim"].first).to include '"restrictionBeginDate":"1974-08-21"'

        # other rights
        expect(solr_doc["otherRights_tesim"].first).to include '"id":"xx06060606"'
        expect(solr_doc["otherRights_tesim"].first).to include '"basis":"fair use"'
        expect(solr_doc["otherRights_tesim"].first).to include '"uri":"http://library.ucsd.edu/lisn/policy/2010-12-31-a.pdf"'
        expect(solr_doc["otherRights_tesim"].first).to include '"permissionType":"display"'
        expect(solr_doc["otherRights_tesim"].first).to include '"permissionBeginDate":"2011-09-24"'
        expect(solr_doc["otherRights_tesim"].first).to include "\"name\":\"#{Rails.configuration.id_namespace}xx09090909\""
        expect(solr_doc["otherRights_tesim"].first).to include "\"role\":\"#{Rails.configuration.id_namespace}bd3004227d\""
      end
      it "should index unit" do
        solr_doc = subject.to_solr
        expect(solr_doc["unit_json_tesim"].first).to include "Library Digital Collections"
      end
      it "should index collection" do
        solr_doc = subject.to_solr
        expect(solr_doc["collection_json_tesim"].join(" ")).to include "UCSD Electronic Theses and Dissertations"
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
      expect(DamsDate.rdf_type).to eq(DAMS.Date)
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
	    expect(subject.content).to be_equivalent_to xml
	
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
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd6212468x")
      end

      it "should have fields" do
        expect(subject.titleValue).to eq("Sample Object Record #8")
        expect(subject.subtitle).to eq("Name/Note/Subject Sampler")
        expect(subject.titleVariant).to eq(["The Whale 2", "The Whale"])
        expect(subject.titleTranslationVariant).to eq(["Translation Variant 2", "Translation Variant"])
	    expect(subject.titleAbbreviationVariant).to eq(["Abbreviation Variant 2", "Abbreviation Variant"])
	    expect(subject.titleAcronymVariant).to eq(["Acronym Variant 2", "Acronym Variant"])
	    expect(subject.titleExpansionVariant).to eq(["Expansion Variant 2", "Expansion Variant"])
      end
      
      it "should index metadata" do
        solr_doc = subject.to_solr
		
        #it "should index iconography" do
        expect(solr_doc["iconography_tesim"]).to eq(["Madonna and Child"])

        #it "should index lithology" do
        expect(solr_doc["lithology_tesim"]).to eq(["test lithology"])
        
        #it "should index series" do
        expect(solr_doc["series_tesim"]).to eq(["test series"])
        
        #it "should index cruise" do
        expect(solr_doc["cruise_tesim"]).to eq(["test cruise"])

        #it "should index lithology" do
        expect(solr_doc["anatomy_tesim"]).to eq(["test anatomy"])
                        
        #it "should index technique" do
        expect(solr_doc["technique_tesim"]).to eq(["Impasto"])

        #it "should index personalName" do
        expect(solr_doc["personalName_tesim"]).to include "Burns, Jack O....."
        expect(solr_doc["personalName_tesim"]).to include "Burns, Jack O.....2"
        
        #it "should index familyName" do
        expect(solr_doc["familyName_tesim"]).to include "Calder (Family : 1757-1959 : N.C.)...."

        #it "should index name" do        
        expect(solr_doc["name_tesim"]).to include "Scripps Institute of Oceanography, Geological Collections"
        expect(solr_doc["name_tesim"]).to include "Yañez, Angélica María"
        expect(solr_doc["name_tesim"]).to include "Personal Name 2"
        expect(solr_doc["name_tesim"]).to include "Name 4"
        expect(solr_doc["name_tesim"]).to include "Conference Name 2"
        expect(solr_doc["name_tesim"]).to include "Family Name 2"
        expect(solr_doc["name_tesim"]).to include "Generic Name Internal"
        expect(solr_doc["name_tesim"]).to include "American Library Association. Annual Conference...."
        expect(solr_doc["name_tesim"]).to include "Lawrence Livermore Laboratory......"
        expect(solr_doc["name_tesim"]).to include "Calder (Family : 1757-1959 : N.C.)...."
        expect(solr_doc["name_tesim"]).to include "Burns, Jack O....."
        expect(solr_doc["name_tesim"]).to include "Burns, Jack O.....2"

        #it "should index conferenceName" do
        expect(solr_doc["conferenceName_tesim"]).to eq(["American Library Association. Annual Conference...."])

        #it "should index corporateName" do
        expect(solr_doc["corporateName_tesim"]).to eq(["Lawrence Livermore Laboratory......"])

        #it "should index complexSubject" do
        expect(solr_doc["complexSubject_tesim"]).to include "Test linked subject--More test"
        
        #it "should have scopeContentNote" do
        expect(solr_doc["scopeContentNote_tesim"]).to eq(["scope content note internal value"])        

        #it "should have preferredCitationNote" do
        expect(solr_doc["preferredCitationNote_tesim"]).to eq(["citation note internal value"])                

        #it "should have CustodialResponsibilityNote" do
        expect(solr_doc["custodialResponsibilityNote_tesim"]).to eq(["Mandeville Special Collections Library....Internal value"])

        #it "should have note" do
		expect(solr_doc["note_tesim"]).to include "Note internal value."
		
        expect(solr_doc["rightsHolder_tesim"]).to include "Administrator, Bob, 1977- internal"
        expect(solr_doc["rightsHolder_tesim"]).to include "UC Regents"
		
        expect(solr_doc["cartographics_json_tesim"].first).to include "1:20000" 

        expect(solr_doc["unit_json_tesim"].first).to include '"id":"xx48484848","code":"rdcp","name":"Research Data Curation Program"'
        
        # title and variant titles
        expect(solr_doc["title_json_tesim"].first).to include '"nonSort":"The","partName":"sample partname","partNumber":"sample partnumber","subtitle":"Name/Note/Subject Sampler","variant":["The Whale 2","The Whale"],"translationVariant":["Translation Variant 2","Translation Variant"],"abbreviationVariant":["Abbreviation Variant 2","Abbreviation Variant"],"acronymVariant":["Acronym Variant 2","Acronym Variant"],"expansionVariant":["Expansion Variant 2","Expansion Variant"]'
        expect(solr_doc["titleVariant_tesim"]).to eq(["The Whale 2", "The Whale"])
        expect(solr_doc["titleTranslationVariant_tesim"]).to eq(["Translation Variant 2", "Translation Variant"])
        expect(solr_doc["titleAbbreviationVariant_tesim"]).to eq(["Abbreviation Variant 2", "Abbreviation Variant"])
        expect(solr_doc["titleAcronymVariant_tesim"]).to eq(["Acronym Variant 2", "Acronym Variant"])
        expect(solr_doc["titleExpansionVariant_tesim"]).to eq(["Expansion Variant 2", "Expansion Variant"])

        # subject
        expect(solr_doc["subject_topic_sim"]).to include "Test linked subject--More test"
        expect(solr_doc["subject_topic_sim"]).to include "Madonna and Child"
        expect(solr_doc["subject_topic_sim"]).to include "Impasto"
        expect(solr_doc["subject_topic_sim"]).to include "Generic Name Internal"
        expect(solr_doc["subject_topic_sim"]).to include "American Library Association. Annual Conference...."
        expect(solr_doc["subject_topic_sim"]).to include "Lawrence Livermore Laboratory......"
        expect(solr_doc["subject_topic_sim"]).to include "Calder (Family : 1757-1959 : N.C.)...."
        expect(solr_doc["subject_topic_sim"]).to include "Burns, Jack O....."
        expect(solr_doc["subject_topic_sim"]).to include "Burns, Jack O.....2"

      end

      it "should index relationship" do
        solr_doc = subject.to_solr
        expect(solr_doc["relationship_json_tesim"].first).to eq('{"Repository":["Conference Name 2","Family Name 2","Name 4","Personal Name 2","Scripps Institute of Oceanography, Geological Collections"],"Creator":["Yañez, Angélica María"]}')
      end
	    
      it "should index collection" do
        solr_doc = subject.to_solr
        expect(solr_doc["collection_json_tesim"].join(" ")).to include "UCSD Electronic Theses and Dissertations"
        expect(solr_doc["collection_json_tesim"].join(" ")).to include "Scripps Institution of Oceanography, Geological Collections"
        expect(solr_doc["collection_json_tesim"].join(" ")).to include "May 2009"
      end
   end

    describe "a complex object with internal classes" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'bd0171551x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectInternal.rdf.xml').read
        subject
      end
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd0171551x")
      end
      it "should index title and collection" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_json_tesim"].first).to include "RNDB11WT-74P (core, piston)"
        expect(solr_doc["collection_json_tesim"].first).to include '"id":"bd24241158","name":"Scripps Institution of Oceanography, Geological Collections","visibility":"public","type":"ProvenanceCollection"'     
		expect(solr_doc["relationship_json_tesim"].first).to include '"Collector":["ROUNDABOUT--11","Thomas Washington"]'
      end
    end
    describe "a complex object with internal classes" do
      subject do
        subject = DamsObjectDatastream.new(double('inner object', :pid=>'bd0171551x', :new_record? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/damsObjectComponentFileMetadata.rdf.xml').read
        subject
      end
      it "should have a component with a first file with file metadata" do
        expect(subject.component.first.file.first.sourcePath).to eq(["/pub/data1/dams_staging/rci/staging/siogeocoll/RNDB_RCI_Jan2013/data/XRF_Data"])
        expect(subject.component.first.file.first.sourceFileName).to eq(["rndb11wt-074P_A_600-748cm_xrfdata_50kV_001.XLS"])
        expect(subject.component.first.file.first.formatName).to eq(["bytestream"])
        expect(subject.component.first.file.first.formatVersion).to eq(["4.0"])
        expect(subject.component.first.file.first.mimeType).to eq(["application/octet-stream"])
        expect(subject.component.first.file.first.use).to eq(["data-service"])
        expect(subject.component.first.file.first.size).to eq(["212480"])
        expect(subject.component.first.file.first.crc32checksum).to eq(["66518753"])
        expect(subject.component.first.file.first.md5checksum).to eq(["688061e851f069bf52513210bd55eef3"])
        expect(subject.component.first.file.first.sha1checksum).to eq(["969e1d6125cec163afd22bb3ff0878e3e5e84695"])
        expect(subject.component.first.file.first.dateCreated).to eq(["2013-01-11T12:29:47-0800"])
        expect(subject.component.first.file.first.objectCategory).to eq(["file"])
        expect(subject.component.first.file.first.compositionLevel).to eq(["0"])
        expect(subject.component.first.file.first.preservationLevel).to eq(["full"])
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
      expect(solr_doc["object_create_dtsi"]).to eq("1993-12-01T00:00:00Z")
    end
  end
end
