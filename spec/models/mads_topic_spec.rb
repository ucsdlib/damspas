# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTopic do
  subject do
    MadsTopic.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Baseball"
    subject.authority = "lcsh"
    subject.sameAs =  "http://id.loc.gov/authorities/subjects/sh85012026"
    subject.valueURI = "http://id.loc.gov/n9999999999"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <mads:Topic rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Baseball</mads:authoritativeLabel>
    <dams:authority>lcsh</dams:authority>
    <owl:sameAs rdf:resource="http://id.loc.gov/authorities/subjects/sh85012026"/>
    <dams:valueURI rdf:resource="http://id.loc.gov/n9999999999"/>
  </mads:Topic>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
