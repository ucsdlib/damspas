# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsLanguageDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsLanguageDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "French"
        subject.name.should == ["French"]
      end   
      it "should have code" do
        subject.code = "fre"
        subject.code.should == ["fre"]
      end          
      it "should have a scheme" do
      	subject.scheme = "bd71341600"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd71341600"		
      end     
    end

    describe "an instance with content" do
      subject do
        subject = MadsLanguageDatastream.new(double('inner object', :pid=>'xx00000006', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsLanguage.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["French"]
      end

      it "should have a hasExactExternalAuthority value" do
        subject.externalAuthorityNode.first.to_s.should == "http://id.loc.gov/vocabulary/languages/fre"
      end
 
      it "should have an code" do
        subject.code.should == ["fre"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsLanguageDatastream::List::LanguageElement
        list[0].elementValue.should == ["French"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["scheme_name_tesim"].should == ["ISO 639 languages"]
        solr_doc["language_element_tesim"].should == ["French"]
      end   

      it "should have a scheme" do
        subject.scheme.name.should == ["ISO 639 languages"]
      end
          
    end
  end
end
