# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
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
 
    end

    describe "an instance with content" do
      subject do
        subject = MadsNameDatastream.new(stub('inner object', :pid=>'bd7509406v', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Generic Name"]
      end

      it "should have a sameAs value" do
        subject.sameAs.to_s.should == "http://id.loc.gov/authorities/names/n2012026835"
      end
 
      it "should have an authority" do
        subject.authority.should == ["naf"]
      end

      it "should have a valueURI" do
        subject.valURI.should == ["http://id.loc.gov/n9999999999"]
      end
                 
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsNameDatastream::List::NameElement
        list[0].elementValue.should == ["Generic Name"]     
        list.size.should == 1     
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["name_element_tesim"].should == ["Generic Name"]
        solr_doc["valueURI_tesim"].should == ["http://id.loc.gov/n9999999999"]
        solr_doc["authority_tesim"].should == ["naf"]
        solr_doc["sameAs_tesim"].should == ["http://id.loc.gov/authorities/names/n2012026835"]
      end    
    end
  end
end
