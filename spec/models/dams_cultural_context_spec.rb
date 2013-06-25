# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCulturalContext do
  subject do
    DamsCulturalContext.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Dutch"
    subject.scheme = "bd45402766"
    subject.externalAuthority =  "http://cultures.org/nl"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:CulturalContext rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Dutch</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://cultures.org/nl"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd45402766"/>
  </dams:CulturalContext>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
