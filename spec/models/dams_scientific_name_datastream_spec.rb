# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScientificNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsScientificNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Western lowland gorilla (Gorilla gorilla gorilla)"
        subject.name.should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
      end   
      it "should have scheme" do
        subject.scheme = "bd6792855f"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd6792855f"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsScientificNameDatastream.new(stub('inner object', :pid=>'bd2662949r', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsScientificName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd6792855f"
      end

      it "should have a externalAuthority" do
        subject.externalAuthority.to_s.should == "http://dbpedia.org/page/Western_lowland_gorilla"
      end
                      
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsScientificNameDatastream::List::ScientificNameElement
        list[0].elementValue.should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["scientificName_element_tesim"].should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
        solr_doc["name_tesim"].should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd6792855f"]
        solr_doc["externalAuthority_tesim"].should == ["http://dbpedia.org/page/Western_lowland_gorilla"]
      end    
    end
  end
end
