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
  </mads:PersonalName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
