# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsFamilyNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsFamilyNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Maria"
        subject.name.should == ["Maria"]
      end   
      it "should have authority" do
        subject.authority = "naf"
        subject.authority.should == ["naf"]
      end  
 
      it "should have full name" do
        list = subject.elementList.first
	    if list != nil   
	    	list[0].elementValue = "Burns, Jack O."
	    	list[0].elementValue.should == ["Burns, Jack O."]
	    end
      end       
    end

    describe "an instance with content" do
      subject do
        subject = MadsFamilyNameDatastream.new(stub('inner object', :pid=>'bd1775562z', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsFamilyName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Calder (Family : 1757-1959 : N.C.)"]
      end

      it "should have a sameAs value" do
        subject.sameAs.should == ["http://id.loc.gov/authorities/names/n2012026835"]
      end
 
      it "should have an authority" do
        subject.authority.should == ["naf"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsPersonalNameDatastream::List::FamilyNameElement
        list[0].elementValue.should == ["Calder (Family :"]  
        list[1].should be_kind_of MadsPersonalNameDatastream::List::DateNameElement
        list[1].elementValue.should == ["1757-1959 :"]  
        list[2].should be_kind_of MadsPersonalNameDatastream::List::TermsOfAddressNameElement
        list[2].elementValue.should == ["N.C.)"]           
        list.size.should == 3     
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["family_name_element_tesim"].should == ["Calder (Family :"]
        solr_doc["date_name_element_tesim"].should == ["1757-1959 :"]
        solr_doc["terms_of_address_name_element_tesim"].should == ["N.C.)"]
      end    
    end
  end
end
