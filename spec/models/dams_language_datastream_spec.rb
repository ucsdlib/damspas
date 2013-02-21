require 'spec_helper'

describe DamsLanguageDatastream do

  describe "a language model" do

    describe "instance populated in-memory" do

      subject { DamsLanguageDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a value" do
        subject.value = "French"
        subject.value.should == ["French"]
      end

      it "should have a code and valueURI" do
        subject.code = "fr"
        subject.code.should == ["fr"]
        subject.valueURI.should == ["http://id.loc.gov/vocabulary/iso639-1/fr"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsLanguageDatastream.new(stub('inner object', :pid=>'bd91134949', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsLanguage.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd91134949"
      end

      it "should have a value" do
        subject.value.should == ["French"]
      end

      it "should have a code" do
        subject.code.should == ["fr"]
      end

      it "should have a valueURI" do
        subject.valueURI.should == ["http://id.loc.gov/vocabulary/iso639-1/fr"]
      end

      it "should have a vocabulary" do
        #subject.vocabulary.should == ["http://library.ucsd.edu/ark:/20775/bb15151515"]
        pending "check vocabulary link #{__FILE__}"
      end

    end
  end
end
