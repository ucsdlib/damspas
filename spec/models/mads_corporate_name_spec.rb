# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsCorporateName do
  let(:params) {
    {
      name: "FullNameValue, Burns, Jack O., Dr., 1977-, NameElementValue",
      externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/names/n90694888"),
      scheme_attributes: [
        id: "http://library.ucsd.edu/ark:/20775/bd0683587d", code: "naf", name: "Library of Congress Name Authority File"
      ],
      familyNameElement_attributes: [{ elementValue: "Burns" }],
      givenNameElement_attributes: [{ elementValue: "Jack O." }],
      termsOfAddressNameElement_attributes: [{ elementValue: "Dr." }],
      dateNameElement_attributes: [{ elementValue: "1977-" }],
      fullNameElement_attributes: [{ elementValue: "FullNameValue" }],
      nameElement_attributes: [{ elementValue: "NameElementValue" }],      
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
    <mads:authoritativeLabel>FullNameValue, Burns, Jack O., Dr., 1977-, NameElementValue</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/names/n90694888"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:FamilyNameElement>
        <mads:elementValue>Burns</mads:elementValue>
      </mads:FamilyNameElement>
      <mads:GivenNameElement>
        <mads:elementValue>Jack O.</mads:elementValue>
      </mads:GivenNameElement>
      <mads:TermsOfAddressNameElement>
         <mads:elementValue>Dr.</mads:elementValue>
      </mads:TermsOfAddressNameElement>
	  <mads:DateNameElement>
        <mads:elementValue>1977-</mads:elementValue>
      </mads:DateNameElement>
      <mads:FullNameElement>
        <mads:elementValue>FullNameValue</mads:elementValue>
      </mads:FullNameElement>
      <mads:NameElement>
        <mads:elementValue>NameElementValue</mads:elementValue>
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
  it "should have givenNameElement" do
    subject.givenNameValue.should == 'Jack O.'
  end
  it "should be able to build a new givenNameElement" do
    subject.elementList.givenNameElement.build
  end
end