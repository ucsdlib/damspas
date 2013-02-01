# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsRole do
  subject do
    DamsRole.new pid: "bd55639754"
  end
  it "should create xml" do
    subject.code = "cre"
    subject.value = "Creator"
    subject.valueURI = "http://id.loc.gov/vocabulary/relators/cre"
    subject.vocabulary = "http://library.ucsd.edu/ark:/20775/bb15151515"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Role rdf:about="http://library.ucsd.edu/ark:/20775/bd55639754">
    <dams:code>cre</dams:code>
    <rdf:value>Creator</rdf:value>
    <dams:valueURI>http://id.loc.gov/vocabulary/relators/cre</dams:valueURI>
    <dams:vocabulary rdf:resource="http://library.ucsd.edu/ark:/20775/bb15151515"/>
  </dams:Role>
</rdf:RDF>
END


    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
