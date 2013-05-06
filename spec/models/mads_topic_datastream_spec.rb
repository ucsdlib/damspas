# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTopicDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsTopicDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Baseball"
        subject.name.should == ["Baseball"]
      end   
      it "should have authority" do
        subject.authority = "lcsh"
        subject.authority.should == ["lcsh"]
      end          
    end

    describe "an instance with content" do
      subject do
        subject = MadsTopicDatastream.new(stub('inner object', :pid=>'bd46424836', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsTopic.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Baseball"]
      end

      it "should have a sameAs value" do
        subject.sameAs.to_s.should == "http://id.loc.gov/authorities/subjects/sh85012026"
      end
 
      it "should have an authority" do
        subject.authority.should == ["lcsh"]
      end
           
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsTopicDatastream::List::TopicElement
        list[0].elementValue.should == ["Baseball"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["topic_element_tesim"].should == ["Baseball"]
      end    
    end
  end
end
