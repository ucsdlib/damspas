# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsOccupation do
  subject do
    MadsOccupation.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Pharmacist"
    subject.scheme = "bd80897986"
    subject.externalAuthority =  "http://id.loc.gov/vocabulary/graphicMaterials/tgm007681"
    subject.elementValue = "Pharmacist"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:Occupation rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Pharmacist</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/vocabulary/graphicMaterials/tgm007681"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd80897986"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:OccupationElement>
        <mads:elementValue>Pharmacist</mads:elementValue>
      </mads:OccupationElement>
    </mads:elementList>    
  </mads:Occupation>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
