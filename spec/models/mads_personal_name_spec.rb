# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsPersonalName do
  subject do
    MadsPersonalName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Maria"
    subject.authority = "naf"
    subject.sameAs =  "http://lccn.loc.gov/n90694888"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:PersonalName rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Maria</mads:authoritativeLabel>
    <dams:authority>naf</dams:authority>
    <owl:sameAs rdf:resource="http://lccn.loc.gov/n90694888"/>
  </mads:PersonalName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
