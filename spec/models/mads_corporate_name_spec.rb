# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsCorporateName do
  subject do
    MadsCorporateName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Lawrence Livermore Laboratory"
    subject.authority = "naf"
    subject.sameAs =  "http://lccn.loc.gov/n50000352"
    subject.valueURI = "http://id.loc.gov/n9999999999"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
   <mads:CorporateName rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <dams:authority>naf</dams:authority>
    <owl:sameAs rdf:resource="http://lccn.loc.gov/n50000352"/>
    <mads:authoritativeLabel>Lawrence Livermore Laboratory</mads:authoritativeLabel>
    <dams:valueURI rdf:resource="http://id.loc.gov/n9999999999"/>
  </mads:CorporateName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
