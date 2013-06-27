# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsIconographyDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsIconographyDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Madonna and Child"
        subject.name.should == ["Madonna and Child"]
      end   
      it "should have scheme" do
        subject.scheme = "bd1980525k"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd1980525k"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsIconographyDatastream.new(stub('inner object', :pid=>'bd65537666', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsIconography.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Madonna and Child"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd1980525k"
      end

      it "should have a externalAuthority" do
        subject.externalAuthority.to_s.should == "http://id.loc.gov/XXX03"
      end
                      
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsIconographyDatastream::List::IconographyElement
        list[0].elementValue.should == ["Madonna and Child"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["iconography_element_tesim"].should == ["Madonna and Child"]
        solr_doc["name_tesim"].should == ["Madonna and Child"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd1980525k"]
        solr_doc["scheme_name_tesim"].should == ["Iconography"]
        solr_doc["externalAuthority_tesim"].should == ["http://id.loc.gov/XXX03"]
      end    
    end
  end
end
