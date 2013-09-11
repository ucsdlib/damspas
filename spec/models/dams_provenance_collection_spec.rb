require 'spec_helper'

describe DamsProvenanceCollection do
  subject do
    DamsProvenanceCollection.new pid: "bb24242424"
  end

  it "should create valid xml" do
    subject.titleValue = "Historical Dissertations"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2010-06-30"
    subject.visibility = "public"
    subject.resource_type = "text"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <dams:ProvenanceCollection rdf:about="#{Rails.configuration.id_namespace}bb24242424">
    <dams:visibility>public</dams:visibility>
    <dams:typeOfResource>text</dams:typeOfResource>
    <dams:title>
      <mads:Title>
        <mads:authoritativeLabel>Historical Dissertations</mads:authoritativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:MainTitleElement>
            <mads:elementValue>Historical Dissertations</mads:elementValue>
          </mads:MainTitleElement>
        </mads:elementList>
      </mads:Title>
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
