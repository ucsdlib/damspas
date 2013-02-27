# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsNoteDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a value" do
        subject.value = "http://libraries.ucsd.edu/ark:/20775/bb80808080"
        subject.value.should == ["http://libraries.ucsd.edu/ark:/20775/bb80808080"]
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
        subject = DamsNoteDatastream.new(stub('inner object', :pid=>'zz11111111', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        subject.value.should == ["http://libraries.ucsd.edu/ark:/20775/bb80808080"]
      end

      it "should have a type" do
        subject.type.should == ["identifier"]
      end
 
      it "should have a displayLabel" do
        subject.displayLabel.should == ["ARK ID"]
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["note_0_value_tesim"].should == ["http://libraries.ucsd.edu/ark:/20775/bb80808080"]
        solr_doc["note_0_type_tesim"].should == ["identifier"]
        solr_doc["note_0_display_label_tesim"].should == ["ARK ID"]
      end    
    end
  end
end
