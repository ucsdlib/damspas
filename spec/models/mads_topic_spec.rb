# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTopic do
  subject do
    MadsTopic.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Baseball"
    subject.scheme = "bd9386739x"
    subject.externalAuthority =  "http://id.loc.gov/authorities/subjects/sh85012026"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <mads:Topic rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Baseball</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85012026"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd9386739x"/>
  </mads:Topic>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
