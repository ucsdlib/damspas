require 'spec_helper'

describe DamsStatuteDatastream do

  describe "a nested_attributes statute model" do

    it "should create a xml" do
      params = {
        statute: { citation: "Family Education Rights and Privacy Act (FERPA)",
			      jurisdiction: "us",
			      note: "Limits disclosure of student information.",
			      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
			      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
        }
      }

      subject = DamsStatuteDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:statute]

      xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Statute rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
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
    <dams:statuteCitation>Family Education Rights and Privacy Act (FERPA)</dams:statuteCitation>
    <dams:statuteJurisdiction>us</dams:statuteJurisdiction>
    <dams:statuteNote>Limits disclosure of student information.</dams:statuteNote>    
  </dams:Statute>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end
    
    describe "instance populated in-memory" do

      subject { DamsStatuteDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end
      it "should have a citation" do
        subject.citation = "Family Education Rights and Privacy Act (FERPA)"
        subject.citation.should == ["Family Education Rights and Privacy Act (FERPA)"]
      end
      it "should have a jurisdiction" do
        subject.jurisdiction = "us"
        subject.jurisdiction.should == ["us"]
      end
      it "should have a note" do
        subject.note = "Limits disclosure of student information."
        subject.note.should == ["Limits disclosure of student information."]
      end
      it "should have a restriction begin date" do
        subject.restrictionBeginDate = "1993-12-31"
        subject.restrictionBeginDate.should == ["1993-12-31"]
      end
      it "should have a restriction end date" do
        subject.restrictionEndDate = "2043-12-31"
        subject.restrictionEndDate.should == ["2043-12-31"]
      end
      it "should have a restriction type" do
        subject.restrictionType = "display"
        subject.restrictionType.should == ["display"]
      end
      it "should have a permission begin date" do
        subject.permissionBeginDate = "1993-12-31"
        subject.permissionBeginDate.should == ["1993-12-31"]
      end
      it "should have a permission end date" do
        subject.permissionEndDate = "2043-12-31"
        subject.permissionEndDate.should == ["2043-12-31"]
      end
      it "should have a permission type" do
        subject.permissionType = "display"
        subject.permissionType.should == ["display"]
      end
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsStatuteDatastream.new(double('inner object', :pid=>'bb05050505', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsStatute.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb05050505"
      end
      it "should have a citation" do
        subject.citation.should == ["Family Education Rights and Privacy Act (FERPA)"]
      end
      it "should have a jurisdiction" do
        subject.jurisdiction.should == ["us"]
      end
      it "should have a note" do
        subject.note.should == ["Limits disclosure of student information."]
      end
      it "should have a restriciton begin date" do
        subject.restrictionBeginDate.should == ["1993-12-31"]
      end
      it "should have a restriciton end date" do
        subject.restrictionEndDate.should == ["2043-12-31"]
      end
      it "should have a restriction type" do
        subject.restrictionType.should == ["display"]
      end
      it "should have solr fields" do
        solr_doc = subject.to_solr
        solr_doc["restrictionType_tesim"].should == ["display"]
        solr_doc["restrictionBeginDate_tesim"].should == ["1993-12-31"]
        solr_doc["restrictionEndDate_tesim"].should == ["2043-12-31"]
      end
    end
  end
end
