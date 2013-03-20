require 'spec_helper'

describe DamsComponent do
  subject do
    DamsComponent.new pid: "zz12345678"
  end

  it "should create valid xml" do
    subject.title = "The Static Image"
    subject.titleType = "main"
    subject.beginDate = "2012-06-24"
    subject.endDate = "2012-06-25"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:Component rdf:about="http://library.ucsd.edu/ark:/20775/zz12345678">
         <dams:date>
          <dams:Date>
            <dams:beginDate>2012-06-24</dams:beginDate>
            <dams:endDate>2012-06-25</dams:endDate>
          </dams:Date>
        </dams:date>
        <dams:title>
          <dams:Title>
            <dams:type>main</dams:type>
            <rdf:value>The Static Image</rdf:value>
          </dams:Title>
        </dams:title>     

      </dams:Component>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
