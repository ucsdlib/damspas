# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsOccupationDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsOccupationDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Pharmacist"
        subject.name.should == ["Pharmacist"]
      end   
      it "should have authority" do
        subject.authority = "tgm"
        subject.authority.should == ["tgm"]
      end          
    end

    describe "an instance with content" do
      subject do
        subject = MadsOccupationDatastream.new(stub('inner object', :pid=>'bd72363644', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsOccupation.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Pharmacist"]
      end

      it "should have a sameAs value" do
        subject.sameAs.should == ["http://id.loc.gov/vocabulary/graphicMaterials/tgm007681"]
      end
 
      it "should have an authority" do
        subject.authority.should == ["tgm"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsOccupationDatastream::List::OccupationElement
        list[0].elementValue.should == ["Pharmacist"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["occupation_element_tesim"].should == ["Pharmacist"]
      end    
    end
  end
end
