require 'spec_helper'

describe DamsOtherRightDatastream do

  describe "a nested_attributes other_rights model" do
    it "should create a xml" do
      params = {
        otherRights: { basis: "fair use", 
	      note: "Educationally important works unavailable due to unknown copyright holders",
	      uri: "http://library.ucsd.edu/lisn/policy/4123412341/",
	      permission_node_attributes: [type: "display",beginDate: "2012-01-01",endDate: "2012-12-31"],
	      relationship_attributes: [name: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX1"),role: RDF::Resource.new("#{Rails.configuration.id_namespace}bbXXXXXXX2")],
	      restriction_node_attributes: [type: "display",beginDate: "1993-12-31",endDate: "2043-12-31"]
        }
      }

      subject = DamsOtherRightDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:otherRights]

      xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
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
      subject.content.should be_equivalent_to xml
    end



    describe "instance populated in-memory" do

      subject { DamsOtherRightDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end
      it "should have a basis" do
        subject.basis = "fair use"
        subject.basis.should == ["fair use"]
      end
      it "should have a note" do
        subject.note = "Educationally important works unavailable due to unknown copyright holders"
        subject.note.should == ["Educationally important works unavailable due to unknown copyright holders"]
      end
      it "should have a uri" do
        subject.uri = "http://library.ucsd.edu/lisn/policy/4123412341/"
        subject.uri.should == ["http://library.ucsd.edu/lisn/policy/4123412341/"]
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
        subject = DamsOtherRightDatastream.new(double('inner object', :pid=>'bb05050505', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsOtherRights.rdf.xml').read
        subject
      end


      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb05050505"
      end
      it "should have a basis" do
        subject.basis.should == ["fair use"]
      end
      it "should have a note" do
        subject.note.should == ["Educationally important works unavailable due to unknown copyright holders"]
      end
      it "should have a uri" do
        subject.uri.should == ["http://library.ucsd.edu/lisn/policy/4123412341/"]
      end
      it "should have a permission begin date" do
        subject.permissionBeginDate.should == ["2012-01-01"]
      end
      it "should have a permission end date" do
        subject.permissionEndDate.should == ["2012-12-31"]
      end
      it "should have a permission type" do
        subject.permissionType.should == ["display"]
      end

      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bbXXXXXXX1"
        subject.relationship.first.role.first.pid.should == "bbXXXXXXX2"
      end

    end
  end
end
