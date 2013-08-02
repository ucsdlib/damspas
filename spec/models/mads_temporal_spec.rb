# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTemporal do
  let(:params) {
    {name: "Socialism", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        temporalElement_attributes: [{ elementValue: "16th century" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    MadsTemporal.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create a xml" do 
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
    subject.damsMetadata.content.should be_equivalent_to xml
  end
  
  it "should have temporalElement" do
    subject.temporalElement.first.elementValue.should == ['16th century']
  end

  it "should be able to build a new temporalElement" do
    subject.elementList.temporalElement.build
  end  
end
