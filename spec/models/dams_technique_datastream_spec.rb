# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsTechniqueDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsTechniqueDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Impasto"
        subject.name.should == ["Impasto"]
      end   
      it "should have scheme" do
        subject.scheme = "bd4198975n"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd4198975n"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsTechniqueDatastream.new(double('inner object', :pid=>'bd8772217q', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsTechnique.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Impasto"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd4198975n"
      end

      it "should have a externalAuthority" do
        subject.externalAuthority.to_s.should == "http://id.loc.gov/XXX04"
      end
                      
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsTechniqueDatastream::List::TechniqueElement
        list[0].elementValue.should == ["Impasto"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["technique_element_tesim"].should == ["Impasto"]
        solr_doc["name_tesim"].should == ["Impasto"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd4198975n"]
        solr_doc["externalAuthority_tesim"].should == ["http://id.loc.gov/XXX04"]
      end    
    end
  end
end
