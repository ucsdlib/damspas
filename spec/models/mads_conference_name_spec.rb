# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsConferenceName do
  let(:params) {
    {
      name: "American Library Association. Annual Conference",
      externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/names/n90694888"),
      scheme_attributes: [
        id: "http://library.ucsd.edu/ark:/20775/bd0683587d", code: "naf", name: "Library of Congress Name Authority File"
      ],
      nameElement_attributes: [{ elementValue: "American Library Association. Annual Conference" }],      
    }
  }
  subject do
    MadsCorporateName.new(pid: 'zzXXXXXXX1').tap do |pn|
      pn.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <mads:CorporateName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>American Library Association. Annual Conference</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/names/n90694888"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:NameElement>
        <mads:elementValue>American Library Association. Annual Conference</mads:elementValue>
      </mads:NameElement>       
    </mads:elementList>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd0683587d">
        <mads:code>naf</mads:code>
        <rdfs:label>Library of Congress Name Authority File</rdfs:label>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:CorporateName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
  it "should have nameElement" do
    subject.nameValue.should == 'American Library Association. Annual Conference'
  end
  it "should be able to build a new nameElement" do
    subject.elementList.nameElement.build
  end
end 