# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCustodialResponsibilityNoteDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsCustodialResponsibilityNoteDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a value" do
        subject.value = "Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)"
        subject.value.should == ["Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)"]
      end   
      it "should have type" do
        subject.type = "custodial_history"
        subject.type.should == ["custodial_history"]
      end   
      it "should have displayLabel" do
        subject.displayLabel = "Digital object made available by"
        subject.displayLabel.should == ["Digital object made available by"]
      end               
    end

    describe "an instance with content" do
      subject do
        subject = DamsCustodialResponsibilityNoteDatastream.new(double('inner object', :pid=>'bd9113515d', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCustodialResponsibilityNote.rdf.xml').read
        subject
      end
           
      it "should have value" do
        subject.value.should == ["Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)"]
      end

      it "should have a type" do
        subject.type.should == ["custodial_history"]
      end
 
      it "should have a displayLabel" do
        subject.displayLabel.should == ["Digital object made available by"]
      end
           
         
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["custodialResponsibilityNote_value_tesim"].should == ["Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)"]
        solr_doc["custodialResponsibilityNote_type_tesim"].should == ["custodial_history"]
        solr_doc["custodialResponsibilityNote_displayLabel_tesim"].should == ["Digital object made available by"]
      end    
    end
  end
end
