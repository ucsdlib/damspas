require 'spec_helper'

describe MadsAuthorityDatastream do

  describe "a MADS Authority model" do

    describe "instance populated in-memory" do

      subject { MadsAuthorityDatastream.new(stub('inner object', :pid=>'bd8396905c', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd8396905c"
      end

      it "should have a name" do
        subject.name = "Test Authority Name"
        subject.name.should == ["Test Authority Name"]
      end

      it "should have a code" do
        subject.code = "Test Authority Code"
        subject.code.should == ["Test Authority Code"]
      end

      it "should have a description" do
        subject.code = "Test Authority Description"
        subject.code.should == ["Test Authority Description"]
      end

      it "should have a scheme" do
        pending "should be able to update scheme"
        #@scheme = MadsScheme.new pid: "bd46424836", name: "Test Scheme Name", code: "Test Scheme Code"
        #subject.scheme.name = "Test Scheme Name"
        #subject.scheme.code = "Test Scheme Code"
        #subject.scheme.first.name.should == ["Test Scheme Name"]
        #subject.scheme.first.code.should == ["Test Scheme Code"]
      end
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = MadsAuthorityDatastream.new(stub('inner object', :pid=>'bd8396905c', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsAuthority.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd8396905c"
      end

      it "should have a name" do
        subject.name.should == ["Repository"]
      end

      it "should have a code" do
        subject.code.should == ["rps"]
      end

      it "should have a description" do
        pending "this causes an 'undefined method split' error"
        #subject.description.should == ["An organization that hosts data or material culture objects and provides services to promote long term, consistent and shared use of those data or objects."]
      end

      it "should have a scheme" do
        pending "should be able to update scheme"
        #subject.scheme.name.should == ["Library of Congress Subject Headings"]
        #subject.scheme.code.should == ["lcsh"]
      end
    end
  end
end
