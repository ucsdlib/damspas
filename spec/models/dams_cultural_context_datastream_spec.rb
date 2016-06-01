# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCulturalContextDatastream do
  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        culturalContext: {
          name: "Dutch", externalAuthority: exturi,
          culturalContextElement_attributes: [{ elementValue: "Dutch" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = DamsCulturalContextDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:culturalContext]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:CulturalContext rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Dutch</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:CulturalContextElement>
        <mads:elementValue>Dutch</mads:elementValue>
      </dams:CulturalContextElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:CulturalContext>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end
    describe "a new instance" do
      subject { DamsCulturalContextDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "Baseball"
        expect(subject.name).to eq(["Baseball"])
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.culturalContextElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Test"])
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.culturalContextElement_attributes = [{ elementValue: nil }]
        expect(subject.name).to eq(["Original"])
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsCulturalContextDatastream.new(double('inner object', :pid=>'bd0410365x', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCulturalContext.rdf.xml').read
        subject
      end

      it "should have name" do
        expect(subject.name).to eq(["Dutch"])
      end

      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd45402766")
      end

      it "should have fields" do
        list = subject.elementList
        expect(list[0]).to be_kind_of Dams::DamsCulturalContext::DamsCulturalContextElement
        expect(list[0].elementValue).to eq("Dutch")
        expect(list.size).to eq(1)
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["cultural_context_tesim"]).to eq(["Dutch"])
        expect(solr_doc["cultural_context_element_tesim"]).to eq(["Dutch"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd45402766"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["Cultural Context"])
      end
    end

  end
end
