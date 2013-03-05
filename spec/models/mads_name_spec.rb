# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsName do
  subject do
    MadsName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Generic Name"
    subject.authority = "naf"
    subject.sameAs =  "http://id.loc.gov/authorities/names/n2012026835"
    subject.valueURI = "http://id.loc.gov/n9999999999"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:Name rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <owl:sameAs rdf:resource="http://id.loc.gov/authorities/names/n2012026835"/>
    <mads:authoritativeLabel>Generic Name</mads:authoritativeLabel>
    <dams:authority>naf</dams:authority>
    <dams:valueURI rdf:resource="http://id.loc.gov/n9999999999"/>
  </mads:Name>    
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
