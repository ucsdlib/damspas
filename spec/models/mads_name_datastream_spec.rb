# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Maria"
        subject.name.should == ["Maria"]
      end   
      it "should have scheme" do
        subject.scheme = "bd0683587d"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd0683587d"
      end  
 
    end

    describe "an instance with content" do
      subject do
        subject = MadsNameDatastream.new(double('inner object', :pid=>'bd7509406v', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Generic Name"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd0683587d"
      end
                 
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsNameElement
        list[0].elementValue.should == "Generic Name"
        list.size.should == 1     
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["name_element_tesim"].should == ["Generic Name"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd0683587d"]
      end    
    end
  end
end
