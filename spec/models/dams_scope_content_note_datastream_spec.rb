# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScopeContentNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsScopeContentNoteDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a value" do
        subject.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        expect(subject.value).to eq(["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."])
      end   
      it "should have type" do
        subject.type = "scope_and_content"
        expect(subject.type).to eq(["scope_and_content"])
      end   
      it "should have displayLabel" do
        subject.displayLabel = "Scope and contents"
        expect(subject.displayLabel).to eq(["Scope and contents"])
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsScopeContentNoteDatastream.new(double('inner object', :pid=>'zz11111111', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsScopeContentNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        expect(subject.value).to eq(["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."])
      end

      it "should have a type" do
        expect(subject.type).to eq(["scope_and_content"])
      end
 
      it "should have a displayLabel" do
        expect(subject.displayLabel).to eq(["Scope and contents"])
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["scopeContentNote_value_tesim"]).to eq(["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."])
        expect(solr_doc["scopeContentNote_type_tesim"]).to eq(["scope_and_content"])
        expect(solr_doc["scopeContentNote_displayLabel_tesim"]).to eq(["Scope and contents"])
      end    
    end
  end
end
