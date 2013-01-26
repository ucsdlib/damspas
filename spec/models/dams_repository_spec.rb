# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsRepository do
  subject do
    DamsRepository.new pid: "bb45454545"
  end
  it "should create a xml" do
    subject.name = "RCI"
    subject.description = "Research Cyberinfrastructure: the hardware, software, and people that support scientific research."
	subject.uri = "http://library.ucsd.edu/repositories/rci/"
    xml =<<END
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
  <dams:Repository rdf:about="http://library.ucsd.edu/ark:/20775/bb45454545">
    <dams:repositoryName>RCI</dams:repositoryName>
    <dams:repositoryDescription>Research Cyberinfrastructure: the hardware, software, and people that support scientific research.</dams:repositoryDescription>
    <dams:repositoryURI>http://library.ucsd.edu/repositories/rci/</dams:repositoryURI>
  </dams:Role>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
