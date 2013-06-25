# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPreferredCitationNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsPreferredCitationNoteDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a value" do
        subject.value = "#{Rails.configuration.id_namespace}bb80808080"
        subject.value.should == ["#{Rails.configuration.id_namespace}bb80808080"]
      end   
      it "should have type" do
        subject.type = "identifier"
        subject.type.should == ["identifier"]
      end   
      it "should have displayLabel" do
        subject.displayLabel = "ARK ID"
        subject.displayLabel.should == ["ARK ID"]
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsPreferredCitationNoteDatastream.new(stub('inner object', :pid=>'bd3959888k', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsPreferredCitationNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        subject.value.should == ["Data at Redshift=1.4 (RD0022)"]
      end

      it "should have a type" do
        subject.type.should == ["citation"]
      end
 
      it "should have a displayLabel" do
        subject.displayLabel.should == ["Citation"]
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["preferredCitationNote_value_tesim"].should == ["Data at Redshift=1.4 (RD0022)"]
        solr_doc["preferredCitationNote_type_tesim"].should == ["citation"]
        solr_doc["preferredCitationNote_displayLabel_tesim"].should == ["Citation"]
      end    
    end
  end
end
