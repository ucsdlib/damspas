# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsBuiltWorkPlace do
  let(:params) {
    {name: "The Getty Center", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        builtWorkPlaceElement_attributes: [{ elementValue: "The Getty Center" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    DamsBuiltWorkPlace.new(pid: 'zzXXXXXXX1').tap do |t|
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
 <dams:BuiltWorkPlace rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>The Getty Center</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:BuiltWorkPlaceElement>
        <mads:elementValue>The Getty Center</mads:elementValue>
      </dams:BuiltWorkPlaceElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:BuiltWorkPlace>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have builtWorkPlaceElement" do
    subject.builtWorkPlaceElement.first.elementValue.should == ['The Getty Center']
  end

  it "should be able to build a new builtWorkPlaceElement" do
    subject.elementList.builtWorkPlaceElement.build
  end
end
