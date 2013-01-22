# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsRdfDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsRdfDatastream.new(stub('inner object', :pid=>'test:1', :new? =>true), 'descMetadata', about:"http://library.ucsd.edu/ark:/20775/") }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/"
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsRdfDatastream.new(stub('inner object', :pid=>'test:1', :new? =>true), 'descMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bb52572546"
      end
      
      
      it "should have fields" do
        subject.resource_type.should == ["text"]
        subject.title.first.value.should == ["Chicano and black radical activism of the 1960s"]
      end

      it "should have collection" do
        #subject.collection.first.scopeContentNote.first.displayLabel == ["Scope and contents"]
        subject.collection.first.to_s.should ==  "http://library.ucsd.edu/ark:/20775/bbXXXXXXX3" 
      end

      it "should have subject" do
        subject.subject.first.authoritativeLabel == ["Academic dissertations"]
        subject.subject.second.authoritativeLabel == ["African Americans--Relations with Mexican Americans--History--20th Century"]
      end

      it "should have relationship" do
        subject.relationship.first.name.first.to_s == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX1"
      end
    end
  end
end
