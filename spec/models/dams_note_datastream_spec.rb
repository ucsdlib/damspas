# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsNoteDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
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
      it "should have internalOnly" do
        subject.internalOnly = "true"
        expect(subject.internalOnly).to eq(["true"])
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsNoteDatastream.new(double('inner object', :pid=>'zz11111111', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        expect(subject.value).to eq(["#{Rails.configuration.id_namespace}bb80808080"])
      end

      it "should have a type" do
        expect(subject.type).to eq(["identifier"])
      end
 
      it "should have a displayLabel" do
        expect(subject.displayLabel).to eq(["ARK ID"])
      end
      it "should have a internalOnly" do
        expect(subject.internalOnly).to eq(["true"])
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["note_value_tesim"]).to eq(["#{Rails.configuration.id_namespace}bb80808080"])
        expect(solr_doc["note_type_tesim"]).to eq(["identifier"])
        expect(solr_doc["note_displayLabel_tesim"]).to eq(["ARK ID"])
        expect(solr_doc["note_internalOnly_tesim"]).to eq(["true"])
      end    
    end
  end
end
