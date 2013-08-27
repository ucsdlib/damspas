# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsNoteDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
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
        subject = DamsNoteDatastream.new(double('inner object', :pid=>'zz11111111', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        subject.value.should == ["#{Rails.configuration.id_namespace}bb80808080"]
      end

      it "should have a type" do
        subject.type.should == ["identifier"]
      end
 
      it "should have a displayLabel" do
        subject.displayLabel.should == ["ARK ID"]
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["note_value_tesim"].should == ["#{Rails.configuration.id_namespace}bb80808080"]
        solr_doc["note_type_tesim"].should == ["identifier"]
        solr_doc["note_displayLabel_tesim"].should == ["ARK ID"]
      end    
    end
  end
end
