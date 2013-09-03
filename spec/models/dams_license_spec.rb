# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsLicense do
  let(:params) {
    { note: "Creative Commons Attribution 3.0 Unported (CC BY 3.0)",
      uri: "http://creativecommons.org/licenses/by/3.0/",
      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
  }}
  subject do
    DamsLicense.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create a rdf/xml" do
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:License rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:licenseNote>Creative Commons Attribution 3.0 Unported (CC BY 3.0)</dams:licenseNote>
    <dams:licenseURI>http://creativecommons.org/licenses/by/3.0/</dams:licenseURI>
    <dams:permission>
      <dams:Permission>
        <dams:beginDate>2012-01-01</dams:beginDate>
        <dams:endDate>2012-12-31</dams:endDate>
        <dams:type>display</dams:type>        
      </dams:Permission>
    </dams:permission>    
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

  it "should have restriction" do
    subject.restrictionBeginDate.should == ["1993-12-31"]
    subject.restrictionEndDate.should == ["2043-12-31"]
    subject.restrictionType.should == ["display"]
    
    subject.restriction_node[0].beginDate.should == ["1993-12-31"]
    subject.restriction_node[0].endDate.should == ["2043-12-31"]
    subject.restriction_node[0].type.should == ["display"]    
  end

  it "should be able to build a new restriction" do
    subject.restriction_node.build
    subject.restriction_node.size.should == 2
  end   
end
