# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTemporal do
  subject do
    MadsTemporal.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "16th century"
    subject.scheme = "bd9386739x"
    subject.externalAuthority = "http://id.loc.gov/n9999999999"
    subject.elementValue = "16th century"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:Temporal rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>16th century</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/n9999999999"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:TemporalElement>
        <mads:elementValue>16th century</mads:elementValue>
      </mads:TemporalElement>
    </mads:elementList>    
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd9386739x"/>
  </mads:Temporal>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
