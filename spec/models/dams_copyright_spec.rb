# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCopyright do
  let(:params) {
    { status: "Under copyright", 
      jurisdiction: "us",
      purposeNote: "This work is available from the UC San Diego Libraries",
      note: "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).",
      date_attributes: [beginDate: "1993-12-31",endDate: "1994-12-31",value: "1993"]
  }}
  subject do
    DamsCopyright.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Copyright rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:copyrightJurisdiction>us</dams:copyrightJurisdiction>
    <dams:copyrightNote>This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).</dams:copyrightNote>
    <dams:copyrightPurposeNote>This work is available from the UC San Diego Libraries</dams:copyrightPurposeNote>
    <dams:copyrightStatus>Under copyright</dams:copyrightStatus>    
    <dams:date>
      <dams:Date>
        <dams:beginDate>1993-12-31</dams:beginDate>
        <dams:endDate>1994-12-31</dams:endDate>
        <rdf:value>1993</rdf:value>        
      </dams:Date>
    </dams:date>
  </dams:Copyright>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have date" do
    subject.beginDate.should == ["1993-12-31"]
    subject.endDate.should == ["1994-12-31"]
    subject.dateValue.should == ["1993"]
  end

  it "should be able to build a new date" do
    subject.date.build
  end
end
