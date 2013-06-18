# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScopeContentNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsScopeContentNoteDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a value" do
        subject.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        subject.value.should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
      end   
      it "should have type" do
        subject.type = "scope_and_content"
        subject.type.should == ["scope_and_content"]
      end   
      it "should have displayLabel" do
        subject.displayLabel = "Scope and contents"
        subject.displayLabel.should == ["Scope and contents"]
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsScopeContentNoteDatastream.new(stub('inner object', :pid=>'zz11111111', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsScopeContentNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        subject.value.should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
      end

      it "should have a type" do
        subject.type.should == ["scope_and_content"]
      end
 
      it "should have a displayLabel" do
        subject.displayLabel.should == ["Scope and contents"]
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["scopeContentNote_value_tesim"].should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
        solr_doc["scopeContentNote_type_tesim"].should == ["scope_and_content"]
        solr_doc["scopeContentNote_displayLabel_tesim"].should == ["Scope and contents"]
      end    
    end
  end
end
