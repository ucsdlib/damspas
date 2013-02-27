# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsFamilyName do
  subject do
    MadsFamilyName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Calder (Family : 1757-1959 : N.C.)"
    subject.authority = "naf"
    subject.sameAs =  "http://id.loc.gov/authorities/names/n2012026835"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <mads:FamilyName rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Calder (Family : 1757-1959 : N.C.)</mads:authoritativeLabel>
    <dams:authority>naf</dams:authority>
    <owl:sameAs rdf:resource="http://id.loc.gov/authorities/names/n2012026835"/>
  </mads:FamilyName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
