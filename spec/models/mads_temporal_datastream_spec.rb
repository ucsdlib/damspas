# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTemporalDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsTemporalDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "16th century"
        subject.name.should == ["16th century"]
      end   
      it "should have authority" do
        subject.authority = "lcsh"
        subject.authority.should == ["lcsh"]
      end          
    end

    describe "an instance with content" do
      subject do
        subject = MadsOccupationDatastream.new(stub('inner object', :pid=>'bd59394235', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsTemporal.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["16th century"]
      end

      it "should have a sameAs value" do
        subject.sameAs.to_s.should == "http://id.loc.gov/authorities/sh2002012470"
      end
 
      it "should have an authority" do
        subject.authority.should == ["lcsh"]
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
