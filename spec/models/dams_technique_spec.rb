# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsTechnique do
  subject do
    DamsTechnique.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Impasto"
    subject.scheme = "bd4198975n"
    subject.externalAuthority =  "http://technique.org/XXX04"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Technique rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Impasto</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://technique.org/XXX04"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd4198975n"/>
  </dams:Technique>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
