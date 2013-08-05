# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGeographic do
  let(:params) {
    {name: "Ness, Loch (Scotland)", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        geographicElement_attributes: [{ elementValue: "Ness, Loch (Scotland)" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    MadsGeographic.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create a xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Geographic rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Ness, Loch (Scotland)</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:GeographicElement>
        <mads:elementValue>Ness, Loch (Scotland)</mads:elementValue>
      </mads:GeographicElement>
    </mads:elementList>
  </mads:Geographic>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have geographicElement" do
    subject.geographicElement.first.elementValue.should == 'Ness, Loch (Scotland)'
  end

  it "should be able to build a new geographicElement" do
    subject.elementList.geographicElement.build
  end
end