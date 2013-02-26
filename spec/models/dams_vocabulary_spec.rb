# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsVocabulary do
  subject do
    DamsVocabulary.new pid: "bb15151515"
  end
  it "should create a xml" do
    subject.description = "Language"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Vocabulary rdf:about="http://library.ucsd.edu/ark:/20775/bb15151515">
    <dams:description>Language</dams:description>
  </dams:Vocabulary>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
