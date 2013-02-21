require 'spec_helper'

describe DamsVocabularyDatastream do

  describe "a vocabulary model" do

    describe "instance populated in-memory" do

      subject { DamsVocabularyDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a description" do
        subject.description = "Test Vocabulary Description"
        subject.description.should == ["Test Vocabulary Description"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsVocabularyDatastream.new(stub('inner object', :pid=>'bb15151515', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsVocabulary.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb15151515"
      end

      it "should have a description" do
        subject.description.should == ["Language"]
      end

    end
  end
end
