# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsStatute do
  subject do
    DamsStatute.new pid: "bb05050505"
  end
  it "should create a xml" do
    subject.citation = "Family Education Rights and Privacy Act (FERPA)"
    subject.jurisdiction = "us"
    subject.note = "Limits disclosure of student information."
    subject.restrictionType = "display"
    subject.restrictionBeginDate = "1993-12-31"
    subject.restrictionEndDate = "2043-12-31"

    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Statute rdf:about="http://library.ucsd.edu/ark:/20775/bb05050505">
    <dams:statuteCitation>Family Education Rights and Privacy Act (FERPA)</dams:statuteCitation>
    <dams:statuteJurisdiction>us</dams:statuteJurisdiction>
    <dams:statuteNote>Limits disclosure of student information.</dams:statuteNote>
    <dams:restriction>
      <dams:Restriction>
        <dams:type>display</dams:type>
        <dams:beginDate>1993-12-31</dams:beginDate>
        <dams:endDate>2043-12-31</dams:endDate>
      </dams:Restriction>
    </dams:restriction>
  </dams:Statute>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
