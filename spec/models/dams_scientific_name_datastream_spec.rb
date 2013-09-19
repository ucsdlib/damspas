# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScientificNameDatastream do
  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        scientificName: {
          name: "Western lowland gorilla (Gorilla gorilla gorilla)", externalAuthority: exturi,
          scientificNameElement_attributes: [{ elementValue: "Western lowland gorilla (Gorilla gorilla gorilla)" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = DamsScientificNameDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:scientificName]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:ScientificName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Western lowland gorilla (Gorilla gorilla gorilla)</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:ScientificNameElement>
        <mads:elementValue>Western lowland gorilla (Gorilla gorilla gorilla)</mads:elementValue>
      </dams:ScientificNameElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:ScientificName>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end
    describe "a new instance" do
      subject { DamsScientificNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Baseball"
        subject.name.should == ["Baseball"]
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.scientificNameElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Test"]
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.scientificNameElement_attributes = [{ elementValue: nil }]
        subject.name.should == ["Original"]
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsScientificNameDatastream.new(double('inner object', :pid=>'bd2662949r', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsScientificName.rdf.xml').read
        subject
      end

      it "should have name" do
        subject.name.should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
      end

      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd6792855f"
      end

      it "should have fields" do
        list = subject.elementList
        list[0].should be_kind_of Dams::DamsScientificName::DamsScientificNameElement
        list[0].elementValue.should == "Western lowland gorilla (Gorilla gorilla gorilla)"
        list.size.should == 1
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["scientific_name_tesim"].should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
        solr_doc["scientific_name_element_tesim"].should == ["Western lowland gorilla (Gorilla gorilla gorilla)"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd6792855f"]
        solr_doc["scheme_name_tesim"].should == ["Scientific Names"]
      end
    end

  end
end
