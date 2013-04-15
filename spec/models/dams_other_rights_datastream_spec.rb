require 'spec_helper'

describe DamsOtherRightsDatastream do

  describe "a other_rights model" do

    describe "instance populated in-memory" do

      subject { DamsOtherRightsDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

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
        subject.uri = "http://libraries.ucsd.edu/lisn/policy/4123412341/"
        subject.uri.should == ["http://libraries.ucsd.edu/lisn/policy/4123412341/"]
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
        subject = DamsOtherRightsDatastream.new(stub('inner object', :pid=>'bb05050505', :new? =>true), 'damsMetadata')
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
        subject.uri.should == ["http://libraries.ucsd.edu/lisn/policy/4123412341/"]
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
