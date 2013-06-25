require 'spec_helper'

describe MadsSchemeDatastream do

  describe "a MADS Scheme model" do

    describe "instance populated in-memory" do

      subject { MadsSchemeDatastream.new(stub('inner object', :pid=>'bd9386739x', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end

      it "should have a name" do
        subject.name = "Test Scheme Name"
        subject.name.should == ["Test Scheme Name"]
      end

      it "should have a code" do
        subject.code = "Test Scheme Code"
        subject.code.should == ["Test Scheme Code"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = MadsSchemeDatastream.new(stub('inner object', :pid=>'bd9386739x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsScheme.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end

      it "should have a name" do
        subject.name.should == ["Library of Congress Subject Headings"]
      end

      it "should have a code" do
        subject.code.should == ["lcsh"]
      end

    end
  end
end
