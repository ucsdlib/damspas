# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsLanguage do
  subject do
    DamsLanguage.new pid: "bb45454545"
  end
  it "should create xml" do
    subject.code = "fr"
    subject.valueURI = "http://id.loc.gov/vocabulary/iso639-1/fr"
    subject.value = "French"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Language rdf:about="http://library.ucsd.edu/ark:/20775/bb45454545">
    <dams:code>fr</dams:code>
    <rdf:value>French</rdf:value>
    <dams:valueURI>http://id.loc.gov/vocabulary/iso639-1/fr</dams:valueURI>
  </dams:Language>
</rdf:RDF>
END
# <dams:vocabulary rdf:resource="http://library.ucsd.edu/ark:/20775/bb15151515"/>

    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
