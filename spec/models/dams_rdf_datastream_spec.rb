# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsRdfDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsRdfDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bb52572546"
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsRdfDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata')
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
      it "should have external subjects"

      it "should have relationship" do
        subject.relationship.first.name.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX1"
        subject.relationship.first.role.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd55639754"
      end

      it "should have date" do
        subject.date.should == ["2010"]
      end

      it "should create a solr document" do
        stub_person = stub(:name => "Maria")
        DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)        
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century",nil]
        solr_doc["title_tesim"].should == ["Chicano and black radical activism of the 1960s"]
        solr_doc["date_tesim"].should == ["2010"]
        solr_doc["name_tesim"].should == ["Maria"]
      end

    end
  end
  
  describe "::Date" do
    it "should have an rdf_type" do
      DamsRdfDatastream::Date.rdf_type.should == DAMS.Date
    end
  end
  
  describe "should store correct xml" do
      subject { DamsRdfDatastream.new(stub('inner object', :pid=>'bb52572546', :new? =>true), 'descMetadata') }
  
	  before do
	    subject.title = "Test Title"
	    subject.date = "2013"
	    #subject.subject = "Test subject"
	  end
	  it "should create a xml" do
	    xml =<<END
	   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dams="http://library.ucsd.edu/ontology/dams#" xmlns:ns1="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <dams:Object rdf:about="http://library.ucsd.edu/ark:/20775/bb52572546">
    <dams:date>
      <dams:Date>
        <ns1:value>2013</ns1:value>
      </dams:Date>
    </dams:date>
    <dams:title>
      <dams:Title>
        <ns1:value>Test Title</ns1:value>
      </dams:Title>
    </dams:title>
  </dams:Object>
</rdf:RDF>
END
	    subject.content.should be_equivalent_to xml
	
	  end
  end
end
