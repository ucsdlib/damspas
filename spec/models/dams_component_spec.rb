require 'spec_helper'

describe DamsComponent do
  subject do
    DamsComponent.new pid: "zz12345678"
  end

  it "should create valid xml" do
    subject.titleValue = "The Static Image"
    subject.beginDate = "2012-06-24"
    subject.endDate = "2012-06-25"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
 <dams:Component rdf:about="#{Rails.configuration.id_namespace}zz12345678">
         <dams:date>
          <dams:Date>
            <dams:beginDate>2012-06-24</dams:beginDate>
            <dams:endDate>2012-06-25</dams:endDate>
          </dams:Date>
        </dams:date>
        <dams:title>
          <mads:Title>
            <mads:authoritativeLabel>The Static Image</mads:authoritativeLabel>
            <mads:elementList rdf:parseType="Collection">
              <mads:MainTitleElement>
                <mads:elementValue>The Static Image</mads:elementValue>
              </mads:MainTitleElement>
            </mads:elementList>
          </mads:Title>
        </dams:title>     

      </dams:Component>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
