# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScientificName do
  subject do
    DamsScientificName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Western lowland gorilla (Gorilla gorilla gorilla)"
    subject.authority = "XXX"
    subject.valueURI =  "http://dbpedia.org/page/Western_lowland_gorilla"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
<dams:ScientificName rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <dams:authority>XXX</dams:authority>
    <dams:valueURI rdf:resource="http://dbpedia.org/page/Western_lowland_gorilla"/>
    <mads:authoritativeLabel>Western lowland gorilla (Gorilla gorilla gorilla)</mads:authoritativeLabel>
  </dams:ScientificName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
