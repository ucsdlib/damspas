# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsLithology do
  let(:params) {
    {name: "Test  Lithology", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        lithologyElement_attributes: [{ elementValue: "Test Lithology" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    DamsLithology.new(pid: 'zzXXXXXXX1').tap do |t|
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
 <dams:Lithology rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Test Lithology</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:LithologyElement>
        <mads:elementValue>Test  Lithology</mads:elementValue>
      </dams:LithologyElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:Lithology>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have lithologyElement" do
    subject.lithologyElement.first.elementValue.should == 'Test Lithology'
  end

  it "should be able to build a new lithologyElement" do
    subject.elementList.lithologyElement.build
  end
end