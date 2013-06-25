# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsLicense do
  subject do
    DamsLicense.new pid: "bb05050505"
  end
  it "should create a xml" do
    subject.note = "Creative Commons Attribution 3.0 Unported (CC BY 3.0)"
    subject.uri = "http://creativecommons.org/licenses/by/3.0/"
    subject.restrictionType = "display"
    subject.restrictionBeginDate = "1993-12-31"
    subject.restrictionEndDate = "2043-12-31"

    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:License rdf:about="#{Rails.configuration.id_namespace}bb05050505">
    <dams:licenseNote>Creative Commons Attribution 3.0 Unported (CC BY 3.0)</dams:licenseNote>
    <dams:licenseURI>http://creativecommons.org/licenses/by/3.0/</dams:licenseURI>
    <dams:restriction>
      <dams:Restriction>
        <dams:type>display</dams:type>
        <dams:beginDate>1993-12-31</dams:beginDate>
        <dams:endDate>2043-12-31</dams:endDate>
      </dams:Restriction>
    </dams:restriction>
  </dams:License>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
