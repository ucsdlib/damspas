# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTemporalDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsTemporalDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "16th century"
        subject.name.should == ["16th century"]
      end   
      it "should have scheme" do
        subject.scheme = "bd9386739x"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = MadsTemporalDatastream.new(double('inner object', :pid=>'bd59394235', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsTemporal.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["16th century"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsTemporalDatastream::List::TemporalElement
        list[0].elementValue.should == ["16th century"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["temporal_element_tesim"].should == ["16th century"]
      end    
    end
  end
end
