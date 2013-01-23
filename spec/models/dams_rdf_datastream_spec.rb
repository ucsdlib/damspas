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
        subject.date.first.value.should == ["2010"]
      end

      it "should create a solr document" do
        stub_person = stub(:name => "Maria")
        DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)        
        solr_doc = subject.to_solr
        solr_doc["subject_t"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century",nil]
        solr_doc["title_t"].should == ["Chicano and black radical activism of the 1960s"]
        solr_doc["date_t"].should == ["2010"]
        solr_doc["name_t"].should == ["Maria"]
      end

    end
  end
end
