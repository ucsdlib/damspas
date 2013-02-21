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
        subject.code = "ISO 3166-1"
        subject.code.should == ["ISO 3166-1"]
      end
      
      it "should have an authorityURI" do
        subject.code = "http://www.loc.gov/standards/mods/"
        subject.code.should == ["http://www.loc.gov/standards/mods/"]
      end
      it "should have a valueURI" do
        subject.code = "http://www.loc.gov/standards/mods/"
        subject.code.should == ["http://www.loc.gov/standards/mods/"]
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
      
      #it "should have a vocabulary" do
        #puts "subject: #{subject.inspect}"
        #subject.vocabulary.should == ["http://library.ucsd.edu/ark:/20775/bb43434343"]
      #end

    end
  end
end
