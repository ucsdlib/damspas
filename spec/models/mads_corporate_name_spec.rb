# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsCorporateName do
  subject do
    MadsCorporateName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Lawrence Livermore Laboratory"
    subject.scheme = "bd0683587d"
    subject.externalAuthority =  "http://id.loc.gov/authorities/names/n50000352"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
   <mads:CorporateName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/names/n50000352"/>
    <mads:authoritativeLabel>Lawrence Livermore Laboratory</mads:authoritativeLabel>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd0683587d"/>
  </mads:CorporateName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
