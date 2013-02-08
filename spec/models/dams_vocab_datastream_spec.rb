require 'spec_helper'

describe DamsVocabDatastream do

  describe "a vocab model" do

    describe "instance populated in-memory" do

      subject { DamsVocabDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a description" do
        subject.description = "Test Vocab Description"
        subject.description.should == ["Test Vocab Description"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsVocabDatastream.new(stub('inner object', :pid=>'bb15151515', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsVocab.rdf.xml').read
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
