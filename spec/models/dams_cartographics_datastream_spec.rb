require 'spec_helper'

describe DamsCartographicsDatastream do

  describe "a vocabulary model" do

    describe "instance populated in-memory" do

      subject { DamsCartographicsDatastream.new(stub('inner object', :pid=>'bb20202020', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb20202020"
      end

      it "should have a projection" do
        subject.projection = "equirectangular"
        subject.projection.should == ["equirectangular"]
      end
      it "should have a referenceSystem" do
        subject.referenceSystem = "WGS84"
        subject.referenceSystem.should == ["WGS84"]
      end
      it "should have a scale" do
        subject.scale = "1:20000"
        subject.scale.should == ["1:20000"]
      end
      it "should have a point" do
        subject.point = "29.67459,-82.37873"
        subject.point.should == ["29.67459,-82.37873"]
      end
      it "should have a line" do
        subject.line = "29.67459,-82.37873 30.12345,-88.12345"
        subject.line.should == ["29.67459,-82.37873 30.12345,-88.12345"]
      end
      it "should have a polygon" do
        subject.polygon = "29.674,-82.378 30.123,-88.123 40.000,-75.000"
        subject.polygon.should == ["29.674,-82.378 30.123,-88.123 40.000,-75.000"]
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsCartographicsDatastream.new(stub('inner object', :pid=>'bb20202020', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCartographics.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb20202020"
      end

      it "should have a projection" do
        subject.projection.should == ["equirectangular"]
      end
      it "should have a referenceSystem" do
        subject.referenceSystem.should == ["WGS84"]
      end
      it "should have a scale" do
        subject.scale.should == ["1:20000"]
      end
      it "should have a point" do
        subject.point.should == ["29.67459,-82.37873"]
      end

    end
  end
end
