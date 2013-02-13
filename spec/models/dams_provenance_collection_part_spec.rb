require 'spec_helper'

describe DamsProvenanceCollectionPart do
  subject do
    DamsProvenanceCollectionPart.new pid: "bb25252525"
  end

  it "should create valid xml" do
    subject.title.build.value = "May 2009"
    subject.title.first.type = "main"
    subject.date.build.beginDate = "2009-05-03"
    subject.date.first.endDate = "2009-05-31"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:ProvenanceCollectionPart rdf:about="http://library.ucsd.edu/ark:/20775/bb25252525">
    <dams:title>
      <dams:Title>
        <dams:type>main</dams:type>
        <rdf:value>May 2009</rdf:value>
      </dams:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
        <dams:endDate>2009-05-31</dams:endDate>
      </dams:Date>
    </dams:date>
  </dams:ProvenanceCollectionPart>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
