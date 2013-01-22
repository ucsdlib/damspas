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
        subject.content = File.new('spec/fixtures/damsObjectModel.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/"
      end
      it "should have controlGroup" do
        subject.controlGroup.should == 'X'
      end
      it "should have mimeType" do
        subject.mimeType.should == 'text/xml'
      end
      it "should have dsid" do
        subject.dsid.should == 'descMetadata'
      end
      it "should have fields" do
        subject.resource_type.should == ["image"]
        subject.title.first.value.should == ["example title"]
      end
    end
  end
end
