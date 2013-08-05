# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsLanguageDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        language: {
          name: "French", code:"fre", externalAuthority: exturi,
          languageElement_attributes: [{ elementValue: "French" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = MadsLanguageDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:language]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Language rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>French</mads:authoritativeLabel>
    <mads:code>fre</mads:code>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:LanguageElement>
        <mads:elementValue>French</mads:elementValue>
      </mads:LanguageElement>
    </mads:elementList>
  </mads:Language>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end
    describe "a new instance" do
      subject { MadsLanguageDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "French"
        subject.name.should == ["French"]
      end

      it "should have a code" do
        subject.name = "fre"
        subject.name.should == ["fre"]
      end
      
      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "French"
        subject.languageElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Test"]
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "French"
        subject.languageElement_attributes = [{ elementValue: nil }]
        subject.name.should == ["French"]
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsLanguageDatastream.new(double('inner object', :pid=>'xx00000006', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsLanguage.rdf.xml').read
        subject
      end

      it "should have name" do
        subject.name.should == ["French"]
      end

      it "should have code" do
        subject.code.should == ["fre"]
      end
      
      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd71341600"
      end

      it "should have fields" do
        list = subject.elementList
        list[0].should be_kind_of MadsLanguageElement
        list[0].elementValue.should == "French"
        list.size.should == 1
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["language_tesim"].should == ["French"]
        solr_doc["language_element_tesim"].should == ["French"]
        solr_doc["code_tesim"].should == ["fre"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd71341600"]
        solr_doc["scheme_name_tesim"].should == ["ISO 639 languages"]
      end
    end

  end
end