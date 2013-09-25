# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsFunction do
  let(:params) {
    {name: "Sample Function", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        functionElement_attributes: [{ elementValue: "Sample Function" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd32433374", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    DamsFunction.new(pid: 'zzXXXXXXX1').tap do |t|
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
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have functionElement" do
    subject.functionElement.first.elementValue.should == 'Sample Function'
  end

  it "should be able to build a new functionElement" do
    subject.elementList.functionElement.build
  end
end
