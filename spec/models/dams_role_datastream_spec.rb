require 'spec_helper'

describe DamsRoleDatastream do

  describe "a role model" do

    describe "instance populated in-memory" do

      subject { DamsRoleDatastream.new(stub('inner object', :pid=>'bd55639754', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd55639754"
      end

      it "should have a value" do
        subject.value = "Actor"
        subject.value.should == ["Actor"]
      end

      it "should have a code and valueURI" do
        subject.code = "act"
        subject.code.should == ["act"]
        subject.valueURI.should == ["http://id.loc.gov/vocabulary/relators/act"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsRoleDatastream.new(stub('inner object', :pid=>'bd55639754', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsRole.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd55639754"
      end

      it "should have a value" do
        subject.value.should == ["Creator"]
      end

      it "should have a code" do
        subject.code.should == ["cre"]
      end
      it "should have a valueURI" do
        subject.valueURI.should == ["http://id.loc.gov/vocabulary/relators/cre"]
      end

      it "should have a vocabulary" do
        #subject.vocabulary.should == ["http://library.ucsd.edu/ark:/20775/bb14141414"]
        pending "check vocabulary link #{__FILE__}"
      end

    end
  end
end
