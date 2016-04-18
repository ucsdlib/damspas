# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsFunctionDatastream do
  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd32433374"
      params = {
        function: {
          name: "Sample Function", externalAuthority: exturi,
          functionElement_attributes: [{ elementValue: "Sample Function" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = DamsFunctionDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:function]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:Function rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Sample Function</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:FunctionElement>
        <mads:elementValue>Sample Function</mads:elementValue>
      </dams:FunctionElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd32433374">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:Function>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end
    describe "a new instance" do
      subject { DamsFunctionDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "Reminder"
        expect(subject.name).to eq(["Reminder"])
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.functionElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Test"])
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.functionElement_attributes = [{ elementValue: nil }]
        expect(subject.name).to eq(["Original"])
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsFunctionDatastream.new(double('inner object', :pid=>'bd7816576v', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsFunction.rdf.xml').read
        subject
      end

      it "should have name" do
        expect(subject.name).to eq(["Sample Function"])
      end

      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd32433374")
      end

      it "should have fields" do
        list = subject.elementList
        expect(list[0]).to be_kind_of Dams::DamsFunction::DamsFunctionElement
        expect(list[0].elementValue).to eq("Sample Function")
        expect(list.size).to eq(1)
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["function_tesim"]).to eq(["Sample Function"])
        expect(solr_doc["function_element_tesim"]).to eq(["Sample Function"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd32433374"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["Functions"])
      end
    end

  end
end
