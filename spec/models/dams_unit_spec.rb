# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsUnit do
  subject do
    DamsUnit.new pid: "bb45454545"
  end
  it "should create a xml" do
    subject.name = "RCI"
    subject.code = "rci"
    subject.description = "Research Cyberinfrastructure: the hardware, software, and people that support scientific research."
	subject.uri = "http://rci.ucsd.edu/"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Unit rdf:about="#{Rails.configuration.id_namespace}bb45454545">
    <dams:unitDescription>
      Research Cyberinfrastructure: the hardware, software, and people that
      support scientific research.
    </dams:unitDescription>
    <dams:unitName>RCI</dams:unitName>
    <dams:code>rci</dams:code>
    <dams:unitURI>http://rci.ucsd.edu/</dams:unitURI>
  </dams:Unit>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
  
  describe "when name is not present" do
    before { subject.name = " " }
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { subject.description = " " }
    it { should_not be_valid }
  end
  
  describe "when code is not present" do
    before { subject.code = " " }
    it { should_not be_valid }
  end
  
  describe "when URI is not present" do
    before { subject.uri = " " }
    it { should_not be_valid }
  end
end
