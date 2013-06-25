# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGeographicDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { MadsGeographicDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Ness, Loch (Scotland)"
        subject.name.should == ["Ness, Loch (Scotland)"]
      end   
      it "should have scheme" do
        subject.scheme = "bd9386739x"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = MadsGeographicDatastream.new(stub('inner object', :pid=>'bd8533304b', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsGeographic.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Ness, Loch (Scotland)"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end
                
      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsGeographicDatastream::List::GeographicElement
        list[0].elementValue.should == ["Ness, Loch (Scotland)"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["geographic_element_tesim"].should == ["Ness, Loch (Scotland)"]
      end    
    end
  end
end
