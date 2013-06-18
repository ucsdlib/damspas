require 'spec_helper'

describe DamsProvenanceCollectionPart do
  subject do
    DamsProvenanceCollectionPart.new pid: "bb25252525"
  end

  it "should create valid xml" do
    subject.titleValue = "May 2009"
    subject.title.first.name = "May 2009"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2009-05-31"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <dams:ProvenanceCollectionPart rdf:about="#{Rails.configuration.id_namespace}bb25252525">
    <dams:title>
      <mads:Title>
        <mads:authoritativeLabel>May 2009</mads:authoritiativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:MainTitleElement>
            <mads:elementValue>May 2009</mads:elementValue>
          </mads:MainTitleElement>
         </mads:elementList>
      </mads:Title>
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
