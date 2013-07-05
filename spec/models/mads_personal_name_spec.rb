# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsPersonalName do
  subject do
    MadsPersonalName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Maria"
    subject.scheme = "bd0683587d"
    subject.externalAuthority =  "http://id.loc.gov/vocabulary/n90694888"
    subject.fullNameValue = "Burns, Jack O."
    subject.familyNameValue = "Burns"
    subject.givenNameValue = "Jack O."
    subject.dateNameValue = "1977-"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:PersonalName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Maria</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/vocabulary/n90694888"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd0683587d"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:FullNameElement>
        <mads:elementValue>Burns, Jack O.</mads:elementValue>
      </mads:FullNameElement>
      <mads:FamilyNameElement>
        <mads:elementValue>Burns</mads:elementValue>
      </mads:FamilyNameElement>
      <mads:GivenNameElement>
        <mads:elementValue>Jack O.</mads:elementValue>
      </mads:GivenNameElement>
	  <mads:DateNameElement>
        <mads:elementValue>1977-</mads:elementValue>
      </mads:DateNameElement>
    </mads:elementList>    
  </mads:PersonalName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
