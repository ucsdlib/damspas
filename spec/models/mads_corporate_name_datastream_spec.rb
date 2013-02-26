# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsCorporateNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsCorporateNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Lawrence Livermore Laboratory"
        subject.name.should == ["Lawrence Livermore Laboratory"]
      end   
      it "should have authority" do
        subject.authority = "naf"
        subject.authority.should == ["naf"]
      end  
 
    end

    describe "an instance with content" do
      subject do
        subject = MadsCorporateNameDatastream.new(stub('inner object', :pid=>'bd8021352s', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsCorporateName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Lawrence Livermore Laboratory"]
      end

      it "should have a sameAs value" do
        subject.sameAs.should == ["http://lccn.loc.gov/n50000352"]
      end
 
      it "should have an authority" do
        subject.authority.should == ["naf"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsPersonalNameDatastream::List::NameElement
        list[0].elementValue.should == ["Lawrence Livermore Laboratory"]     
        list.size.should == 1        
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["name_element_tesim"].should == ["Lawrence Livermore Laboratory"]
      end    
    end
  end
end
