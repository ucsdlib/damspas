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

      subject = DamsCulturalContextDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
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
      subject.content.should be_equivalent_to xml
    end
    describe "a new instance" do
      subject { DamsCulturalContextDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Baseball"
        subject.name.should == ["Baseball"]
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.culturalContextElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Test"]
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.culturalContextElement_attributes = [{ elementValue: nil }]
        subject.name.should == ["Original"]
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsCulturalContextDatastream.new(double('inner object', :pid=>'bd0410365x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCulturalContext.rdf.xml').read
        subject
      end

      it "should have name" do
        subject.name.should == ["Dutch"]
      end

      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd45402766"
      end

      it "should have fields" do
        list = subject.elementList
        list[0].should be_kind_of Dams::DamsCulturalContext::DamsCulturalContextElement
        list[0].elementValue.should == "Dutch"
        list.size.should == 1
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["cultural_context_tesim"].should == ["Dutch"]
        solr_doc["cultural_context_element_tesim"].should == ["Dutch"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd45402766"]
        solr_doc["scheme_name_tesim"].should == ["Cultural Context"]
      end
    end

  end
end