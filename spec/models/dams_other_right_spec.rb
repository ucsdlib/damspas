# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'rdf'

describe DamsOtherRight do
  let(:params) {
    { basis: "fair use", 
      note: "Educationally important works unavailable due to unknown copyright holders",
      uri: "http://library.ucsd.edu/lisn/policy/4123412341/",
      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
      relationship_attributes: [name: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX1"),role: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX2")],
      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
  }}
  subject do
    DamsOtherRight.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end

  it "should create a rdf/xml" do
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:OtherRights rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:otherRightsBasis>fair use</dams:otherRightsBasis>
    <dams:otherRightsNote>Educationally important works unavailable due to unknown copyright holders</dams:otherRightsNote>
    <dams:otherRightsURI>http://library.ucsd.edu/lisn/policy/4123412341/</dams:otherRightsURI>
    <dams:permission>
      <dams:Permission>
        <dams:beginDate>2012-01-01</dams:beginDate>
        <dams:endDate>2012-12-31</dams:endDate>
        <dams:type>display</dams:type>        
      </dams:Permission>
    </dams:permission>
    <dams:relationship>
      <dams:Relationship>
       <dams:name rdf:resource="#{Rails.configuration.id_namespace}bbXXXXXXX1"/>
       <dams:role rdf:resource="#{Rails.configuration.id_namespace}bbXXXXXXX2"/>
      </dams:Relationship>
    </dams:relationship>
    <dams:restriction>
      <dams:Restriction>
        <dams:type>display</dams:type>
        <dams:beginDate>1993-12-31</dams:beginDate>
        <dams:endDate>2043-12-31</dams:endDate>
      </dams:Restriction>
    </dams:restriction>    
  </dams:OtherRights>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
  
  it "should have permission" do
    subject.permissionBeginDate.should == ["2012-01-01"]
    subject.permissionEndDate.should == ["2012-12-31"]
    subject.permissionType.should == ["display"]
    
    subject.permission_node[0].beginDate.should == ["2012-01-01"]
    subject.permission_node[0].endDate.should == ["2012-12-31"]
    subject.permission_node[0].type.should == ["display"]    
  end

  it "should be able to build a new permission" do
    subject.permission_node.build
    subject.permission_node.size.should == 2
  end  
end
