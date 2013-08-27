# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsBuiltWorkPlaceDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsBuiltWorkPlaceDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "The Getty Center"
        subject.name.should == ["The Getty Center"]
      end   
      it "should have scheme" do
        subject.scheme = "bd2936165m"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd2936165m"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsBuiltWorkPlaceDatastream.new(double('inner object', :pid=>'bd1707307x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsBuiltWorkPlace.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["The Getty Center"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd2936165m"
      end

      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsBuiltWorkPlaceDatastream::List::BuiltWorkPlaceElement
        list[0].elementValue.should == ["The Getty Center"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["builtWorkPlace_element_tesim"].should == ["The Getty Center"]
        solr_doc["name_tesim"].should == ["The Getty Center"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd2936165m"]
        solr_doc["externalAuthority_tesim"].should == ["http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994"]
      end    
    end
  end
end
