# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPreferredCitationNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsPreferredCitationNoteDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a value" do
        subject.value = "#{Rails.configuration.id_namespace}bb80808080"
        expect(subject.value).to eq(["#{Rails.configuration.id_namespace}bb80808080"])
      end   
      it "should have type" do
        subject.type = "identifier"
        expect(subject.type).to eq(["identifier"])
      end   
      it "should have displayLabel" do
        subject.displayLabel = "ARK ID"
        expect(subject.displayLabel).to eq(["ARK ID"])
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsPreferredCitationNoteDatastream.new(double('inner object', :pid=>'bd3959888k', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsPreferredCitationNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        expect(subject.value).to eq(["Data at Redshift=1.4 (RD0022)"])
      end

      it "should have a type" do
        expect(subject.type).to eq(["citation"])
      end
 
      it "should have a displayLabel" do
        expect(subject.displayLabel).to eq(["Citation"])
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["preferredCitationNote_value_tesim"]).to eq(["Data at Redshift=1.4 (RD0022)"])
        expect(solr_doc["preferredCitationNote_type_tesim"]).to eq(["citation"])
        expect(solr_doc["preferredCitationNote_displayLabel_tesim"]).to eq(["Citation"])
      end    
    end
  end
end
