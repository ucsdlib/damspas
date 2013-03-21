require 'spec_helper'

describe DamsProvenanceCollection do
  subject do
    DamsProvenanceCollection.new pid: "bb24242424"
  end

  it "should create valid xml" do
    subject.titleValue = "Historical Dissertations"
    subject.titleType = "main"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2010-06-30"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:ProvenanceCollection rdf:about="http://library.ucsd.edu/ark:/20775/bb24242424">
    <dams:title>
      <dams:Title>
        <dams:type>main</dams:type>
        <rdf:value>Historical Dissertations</rdf:value>
      </dams:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
        <dams:endDate>2010-06-30</dams:endDate>    
      </dams:Date>
    </dams:date>
  </dams:ProvenanceCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
