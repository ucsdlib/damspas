require 'spec_helper'

describe DamsVocabularyEntryDatastream do

  describe "a Vocabulary Entry model" do

    describe "instance populated in-memory" do

      subject { DamsVocabularyEntryDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a value" do
        subject.value = "United States"
        subject.value.should == ["United States"]
      end

      it "should have a code" do
        subject.code = "us"
        subject.code.should == ["us"]
      end

      it "should have an authority" do
        subject.authority = "ISO 3166-1"
        subject.authority.should == ["ISO 3166-1"]
      end
      
      it "should have an authorityURI" do
        subject.authorityURI = "http://www.loc.gov/standards/mods/"
        subject.authorityURI.should == "http://www.loc.gov/standards/mods/"
      end
      it "should have a valueURI" do
        subject.valueURI = "http://www.loc.gov/standards/mods/"
        subject.valueURI.should == "http://www.loc.gov/standards/mods/"
      end      
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsVocabularyEntryDatastream.new(stub('inner object', :pid=>'bb47474747', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsVocabularyEntry.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb47474747"
      end

      it "should have a value" do
        subject.value.should == ["United States"]
      end

      it "should have a code" do
        subject.code.should == ["us"]
      end

      it "should have a valueURI" do
        subject.valueURI.should == ["http://www.loc.gov/standards/mods/"]
      end

      it "should have an authorityURI" do
        subject.authorityURI.should == ["http://www.loc.gov/standards/mods/"]
      end

      it "should have an authority" do
        subject.authority.should == ["ISO 3166-1"]
      end
      
      it "should have a vocabulary" do
        subject.vocabulary.should == ["http://library.ucsd.edu/ark:/20775/bb43434343"]
      end
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["code_tesim"].should == ["us"]
        solr_doc["value_tesim"].should == ["United States"]
        solr_doc["authority_tesim"].should == ["ISO 3166-1"]
        solr_doc["vocabulary_tesim"].should == ["http://library.ucsd.edu/ark:/20775/bb43434343"]
        solr_doc["valueURI_tesim"].should == ["http://www.loc.gov/standards/mods/"]
        solr_doc["authorityURI_tesim"].should == ["http://www.loc.gov/standards/mods/"]
      end 
    end
  end
end
