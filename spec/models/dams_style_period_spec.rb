# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsStylePeriod do
  subject do
    DamsStylePeriod.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Impressionism"
    subject.authority = "XXX"
    subject.valueURI =  "http://id.loc.gov/XXX05"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:StylePeriod rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Impressionism</mads:authoritativeLabel>
    <dams:authority>XXX</dams:authority>
    <dams:valueURI rdf:resource="http://id.loc.gov/XXX05"/>
  </dams:StylePeriod>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
