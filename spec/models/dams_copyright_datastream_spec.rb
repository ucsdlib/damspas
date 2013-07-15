require 'spec_helper'

describe DamsCopyrightDatastream do

  describe "a copyright model" do

    describe "instance populated in-memory" do

      subject { DamsCopyrightDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end
      it "should have a status" do
        subject.status = "Under copyright -- 3rd Party"
        subject.status.should == ["Under copyright -- 3rd Party"]
      end
      it "should have a jurisdiction" do
        subject.jurisdiction = "us"
        subject.jurisdiction.should == ["us"]
      end
      it "should have a purpose note" do
        subject.purposeNote = "This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."
        subject.purposeNote.should == ["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."]
      end
      it "should have a note" do
        subject.note = "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."
        subject.note.should == ["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."]
      end
      it "should have a begin date" do
        subject.beginDate = "1993-12-31"
        subject.beginDate.should == ["1993-12-31"]
      end
    end


    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsCopyrightDatastream.new(double('inner object', :pid=>'bb05050505', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCopyright.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb05050505"
      end
      it "should have a status" do
        subject.status.should == ["Under copyright -- 3rd Party"]
      end
      it "should have a jurisdiction" do
        subject.jurisdiction.should == ["us"]
      end
      it "should have a purpose note" do
        subject.purposeNote.should == ["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."]
      end
      it "should have a note" do
        subject.note.should == ["This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by 'fair use' requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries."]
      end
      it "should have a begin date" do
        subject.beginDate.should == ["1993-12-31"]
      end
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["status_tesim"].should == ["Under copyright -- 3rd Party"]
        solr_doc["jurisdiction_tesim"].should == ["us"]
        solr_doc["beginDate_tesim"].should == ["1993-12-31"]
        solr_doc["purposeNote_tesim"].should == ["This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study."]
      end
    end
  end
end
