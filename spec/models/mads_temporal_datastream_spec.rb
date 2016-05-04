# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTemporalDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        temporal: {
          name: "16th century", externalAuthority: exturi,
          temporalElement_attributes: [{ elementValue: "16th century" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = MadsTemporalDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:temporal]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:Temporal rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>16th century</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <mads:TemporalElement>
        <mads:elementValue>16th century</mads:elementValue>
      </mads:TemporalElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </mads:Temporal>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end
  end
  
  describe "a complex data model" do    
    describe "a new instance" do
      subject { MadsTemporalDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "16th century"
        expect(subject.name).to eq(["16th century"])
      end
        
      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.temporalElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Test"])
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.temporalElement_attributes = [{ elementValue: nil }]
        expect(subject.name).to eq(["Original"])
      end      
    end

    describe "an instance with content" do
      subject do
        subject = MadsTemporalDatastream.new(double('inner object', :pid=>'bd59394235', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsTemporal.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        expect(subject.name).to eq(["16th century"])
      end
 
      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd9386739x")
      end
           
      it "should have fields" do
        list = subject.elementList
        expect(list[0]).to be_kind_of MadsTemporalDatastream::MadsTemporalElement
        expect(list[0].elementValue).to eq("16th century")       
        expect(list.size).to eq(1)       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["temporal_tesim"]).to eq(["16th century"])
        expect(solr_doc["temporal_element_tesim"]).to eq(["16th century"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd9386739x"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["Library of Congress Subject Headings"])
      end    
    end
  end
end
