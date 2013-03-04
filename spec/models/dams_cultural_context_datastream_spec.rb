# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCulturalContextDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsCulturalContextDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Dutch"
        subject.name.should == ["Dutch"]
      end   
      it "should have authority" do
        subject.authority = "XXX"
        subject.authority.should == ["XXX"]
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsCulturalContextDatastream.new(stub('inner object', :pid=>'bd0410365x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCulturalContext.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Dutch"]
      end
 
      it "should have an authority" do
        subject.authority.should == ["XXX"]
      end

      it "should have a valueURI" do
        subject.valURI.should == ["http://id.loc.gov/XXX01"]
      end
                      
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsCulturalContextDatastream::List::CulturalContextElement
        list[0].elementValue.should == ["Dutch"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["culturalContext_element_tesim"].should == ["Dutch"]
        solr_doc["name_tesim"].should == ["Dutch"]
        solr_doc["authority_tesim"].should == ["XXX"]
        solr_doc["valueURI_tesim"].should == ["http://id.loc.gov/XXX01"]
      end    
    end
  end
end
