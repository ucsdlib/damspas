# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsPersonalName do
  subject do
    MadsPersonalName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    exturi = RDF::Resource.new "http://id.loc.gov/authorities/names/n90694888"
    scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd0683587d"
    params = {
      personalName: {
        name: "Burns, Jack O., Dr., 1977-", externalAuthority: exturi,
        elementList_attributes: [
          familyNameElement_attributes: [{ elementValue: "Burns" }],
          givenNameElement_attributes: [{ elementValue: "Jack O." }],
          termsOfAddressNameElement_attributes: [{ elementValue: "Dr." }],
          dateNameElement_attributes: [{ elementValue: "1977-" }]
        ],
        scheme_attributes: [
          id: scheme, code: "naf", name: "Library of Congress Name Authority File"
        ]
      }
    }
    subject.attributes = params[:personalName]
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <mads:PersonalName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Burns, Jack O., Dr., 1977-</mads:authoritativeLabel>
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
    </mads:elementList>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd0683587d">
        <mads:code>naf</mads:code>
        <rdfs:label>Library of Congress Name Authority File</rdfs:label>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:PersonalName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
