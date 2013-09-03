require 'spec_helper'

describe DamsLicenseDatastream do

  describe "a nested_attributes license model" do
    it "should create a xml" do
      params = {
        license: { note: "Creative Commons Attribution 3.0 Unported (CC BY 3.0)",
					   uri: "http://creativecommons.org/licenses/by/3.0/",
					   permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
					   restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
        }
      }

      subject = DamsLicenseDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:license]

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
      subject.content.should be_equivalent_to xml
    end
    describe "instance populated in-memory" do

      subject { DamsLicenseDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end
      it "should have a note" do
        subject.note = "Creative Commons Attribution 3.0 Unported (CC BY 3.0)"
        subject.note.should == ["Creative Commons Attribution 3.0 Unported (CC BY 3.0)"]
      end
      it "should have a uri" do
        subject.uri = "http://creativecommons.org/licenses/by/3.0/"
        subject.uri.should == ["http://creativecommons.org/licenses/by/3.0/"]
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
        subject = DamsLicenseDatastream.new(double('inner object', :pid=>'bb05050505', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsLicense.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb05050505"
      end
      it "should have a note" do
        subject.note.should == ["Creative Commons Attribution 3.0 Unported (CC BY 3.0)"]
      end
      it "should have a uri" do
        subject.uri.should == ["http://creativecommons.org/licenses/by/3.0/"]
      end
      it "should have a permission begin date" do
        subject.permissionBeginDate.should == ["1993-12-31"]
      end
      it "should have a permission end date" do
        subject.permissionEndDate.should == ["2043-12-31"]
      end
      it "should have a permission type" do
        subject.permissionType.should == ["display"]
      end

    end
  end
end
