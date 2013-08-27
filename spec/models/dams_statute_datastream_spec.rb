require 'spec_helper'

describe DamsStatuteDatastream do

  describe "a statute model" do

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

    end
  end
end
