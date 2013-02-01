# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsObjectDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bb52572546"
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsObjectDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bb52572546"
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
        stub_person = stub(:name => "Maria")
        DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)        
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century","stubbed"]
        solr_doc["title_tesim"].should == ["Chicano and black radical activism of the 1960s"]
        solr_doc["date_tesim"].should == ["2010"]
        solr_doc["name_tesim"].should == ["Maria"]
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

      it "should have solr doc" do
        solr_doc = subject.to_solr
        solr_doc["component_1_title_tesim"].should == ["The Static Image"]
        solr_doc["component_2_title_tesim"].should == ["Supplementary Image"]
#puts solr_doc
      end
    end
  end
  
  describe "::Date" do
    it "should have an rdf_type" do
      DamsObjectDatastream::Date.rdf_type.should == DAMS.Date
    end
  end
  
  describe "should store correct xml" do
      subject { DamsObjectDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata') }
  
	  before do
	    subject.title = "Test Title"
	    subject.date = "2013"
	    #subject.subject = "Test subject"
	  end
	  it "should create a xml" do
	    xml =<<END
	   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Object rdf:about="http://library.ucsd.edu/ark:/20775/bb52572546">
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
