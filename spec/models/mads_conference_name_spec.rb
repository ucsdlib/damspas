# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsConferenceName do
  subject do
    MadsConferenceName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "American Library Association. Annual Conference"
    subject.authority = "naf"
    subject.sameAs =  "http://id.loc.gov/authorities/names/n2009036967"
    subject.valueURI = "http://id.loc.gov/n9999999999"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <mads:ConferenceName rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <owl:sameAs rdf:resource="http://id.loc.gov/authorities/names/n2009036967"/>
    <dams:authority>naf</dams:authority>
    <mads:authoritativeLabel>American Library Association. Annual Conference</mads:authoritativeLabel>
    <dams:valueURI rdf:resource="http://id.loc.gov/n9999999999"/>
  </mads:ConferenceName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
