# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsAnatomy do
  let(:params) {
    {name: "Test  Anatomy", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        anatomyElement_attributes: [{ elementValue: "Test Anatomy" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    DamsAnatomy.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:Anatomy rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Test Anatomy</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:AnatomyElement>
        <mads:elementValue>Test  Anatomy</mads:elementValue>
      </dams:AnatomyElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:Anatomy>
</rdf:RDF>
END
    expect(subject.damsMetadata.content).to be_equivalent_to xml
  end

  it "should have anatomyElement" do
    expect(subject.anatomyElement.first.elementValue).to eq('Test Anatomy')
  end

  it "should be able to build a new anatomyElement" do
    subject.elementList.anatomyElement.build
  end
end