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
        DamsSubject.should_receive(:find).with('bbXXXXXXX5').and_return(stub(:name =>'stubbed'))
        #stub_person = stub(:name => "Maria")
        #DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)        
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century","stubbed"]
        solr_doc["title_tesim"].should == ["Chicano and black radical activism of the 1960s"]
        solr_doc["date_tesim"].should == ["2010"]
        solr_doc["name_tesim"].should == ["Ya\xF1ez, Ang\xE9lica Mar\xEDa"]
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
      
      it "should have fields" do
        subject.resource_type.should == ["mixed material"]
        subject.title.should == ["Sample Complex Object Record #1"]
        subject.subtitle.should == ["a dissertation with a single attached image"]
        subject.relatedResource.first.type.should == ["online exhibit"]
        subject.relatedResource.first.uri.should == ["http://foo.com/1234"]
        subject.relatedResource.first.description.should == ["Sample Complex Object Record #1: The Exhibit!"]
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

      it "should index component metadata" do
        solr_doc = subject.to_solr
        solr_doc["component_1_title_tesim"].should == ["The Static Image"]
        solr_doc["component_2_title_tesim"].should == ["Supplementary Image"]
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
      it "should index rights metadata" do
        solr_doc = subject.to_solr

        # copyright
        solr_doc["copyright_id_tesim"].should == ["bb05050505"]
        solr_doc["copyright_status_tesim"].should == ["Under copyright -- 3rd Party"]
        solr_doc["copyright_jurisdiction_tesim"].should == ["us"]
        solr_doc["copyright_note_tesim"].should == ["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \\\\\"fair use\\\\\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."]
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
end
