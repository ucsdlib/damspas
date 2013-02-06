require 'spec_helper'

describe DamsUnitDatastream do

  describe "a unit model" do

    describe "instance populated in-memory" do

      subject { DamsUnitDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a name" do
        subject.name = "Test Unit"
        subject.name.should == ["Test Unit"]
      end

      it "should have a description" do
        subject.description = "Test Unit Description"
        subject.description.should == ["Test Unit Description"]
      end

      it "should have a code" do
        subject.code = "xyz"
        subject.code.should == ["xyz"]
      end

      it "should have a uri" do
        subject.uri = "http://library.ucsd.edu/units/test/"
        subject.uri.should == ["http://library.ucsd.edu/units/test/"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsUnitDatastream.new(stub('inner object', :pid=>'bb45454545', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsUnit.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb45454545"
      end

      it "should have a name" do
        subject.name.should == ["RCI"]
      end

      it "should have a description" do
        subject.description.should == ["Research Cyberinfrastructure: the hardware, software, and people that support scientific research."]
      end

      it "should have a code" do
        subject.code.should == ["rci"]
      end

      it "should have a uri" do
        subject.uri.should == ["http://rci.ucsd.edu/"]
      end

    end
  end
end
