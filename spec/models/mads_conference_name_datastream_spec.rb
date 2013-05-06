# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsConferenceNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsConferenceNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
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
        subject = MadsConferenceNameDatastream.new(stub('inner object', :pid=>'bd0478622c', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsConferenceName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["American Library Association. Annual Conference"]
      end

      it "should have a sameAs value" do
        subject.sameAs.to_s.should == "http://id.loc.gov/authorities/names/n2009036967"
      end
 
      it "should have an authority" do
        subject.authority.should == ["naf"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsConferenceNameDatastream::List::NameElement
        list[0].elementValue.should == ["American Library Association."]  
        list[1].should be_kind_of MadsConferenceNameDatastream::List::NameElement
        list[1].elementValue.should == ["Annual Conference"]   
        list.size.should == 2     
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["name_element_tesim"].should == ["American Library Association.", "Annual Conference"]
      end    
    end
  end
end
