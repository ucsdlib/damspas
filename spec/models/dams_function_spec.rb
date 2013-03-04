# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsFunction do
  subject do
    DamsFunction.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Sample Function"
    subject.authority = "XXX"
    subject.valueURI =  "http://id.loc.gov/XXX02"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Function rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Sample Function</mads:authoritativeLabel>
    <dams:authority>XXX</dams:authority>
    <dams:valueURI rdf:resource="http://id.loc.gov/XXX02"/>
  </dams:Function>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
