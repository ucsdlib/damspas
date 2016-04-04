# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGenreFormDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        genreForm: {
          name: "Film and video adaptions", externalAuthority: exturi,
          genreFormElement_attributes: [{ elementValue: "Film and video adaptions" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = MadsGenreFormDatastream.new(double("inner object", pid:"zzXXXXXXX1", new_record?: true))
      subject.attributes = params[:genreForm]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:GenreForm rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Film and video adaptions</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:GenreFormElement>
        <mads:elementValue>Film and video adaptions</mads:elementValue>
      </mads:GenreFormElement>
    </mads:elementList>
  </mads:GenreForm>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end
    describe "a new instance" do
      subject { MadsGenreFormDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "Baseball"
        expect(subject.name).to eq(["Baseball"])
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.genreFormElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Test"])
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.genreFormElement_attributes = [{ elementValue: nil }]
        expect(subject.name).to eq(["Original"])
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsGenreFormDatastream.new(double('inner object', :pid=>'bd9796116g', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsGenreForm.rdf.xml').read
        subject
      end

      it "should have name" do
        expect(subject.name).to eq(["Film and video adaptions"])
      end

      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd9386739x")
      end

      it "should have fields" do
        list = subject.elementList
        expect(list[0]).to be_kind_of MadsGenreFormDatastream::MadsGenreFormElement
        expect(list[0].elementValue).to eq("Film and video adaptions")
        expect(list.size).to eq(1)
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["genre_form_tesim"]).to eq(["Film and video adaptions"])
        expect(solr_doc["genre_form_element_tesim"]).to eq(["Film and video adaptions"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd9386739x"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["Library of Congress Subject Headings"])
      end
    end

  end
end
