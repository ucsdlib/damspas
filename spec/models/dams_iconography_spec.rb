# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsIconography do
  subject do
    DamsIconography.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Madonna and Child"
    subject.authority = "XXX"
    subject.valueURI =  "http://id.loc.gov/XXX03"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Iconography rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">  
    <dams:authority>XXX</dams:authority>
    <dams:valueURI rdf:resource="http://id.loc.gov/XXX03"/>
    <mads:authoritativeLabel>Madonna and Child</mads:authoritativeLabel>    
  </dams:Iconography>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
