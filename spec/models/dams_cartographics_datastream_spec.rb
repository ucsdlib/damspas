require 'spec_helper'

describe DamsCartographicsDatastream do

  describe "a vocabulary model" do

    describe "instance populated in-memory" do

      subject { DamsCartographicsDatastream.new(double('inner object', :pid=>'bb20202020', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb20202020")
      end

      it "should have a projection" do
        subject.projection = "equirectangular"
        expect(subject.projection).to eq(["equirectangular"])
      end
      it "should have a referenceSystem" do
        subject.referenceSystem = "WGS84"
        expect(subject.referenceSystem).to eq(["WGS84"])
      end
      it "should have a scale" do
        subject.scale = "1:20000"
        expect(subject.scale).to eq(["1:20000"])
      end
      it "should have a point" do
        subject.point = "29.67459,-82.37873"
        expect(subject.point).to eq(["29.67459,-82.37873"])
      end
      it "should have a line" do
        subject.line = "29.67459,-82.37873 30.12345,-88.12345"
        expect(subject.line).to eq(["29.67459,-82.37873 30.12345,-88.12345"])
      end
      it "should have a polygon" do
        subject.polygon = "29.674,-82.378 30.123,-88.123 40.000,-75.000"
        expect(subject.polygon).to eq(["29.674,-82.378 30.123,-88.123 40.000,-75.000"])
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsCartographicsDatastream.new(double('inner object', :pid=>'bb20202020', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCartographics.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb20202020")
      end

      it "should have a projection" do
        expect(subject.projection).to eq(["equirectangular"])
      end
      it "should have a referenceSystem" do
        expect(subject.referenceSystem).to eq(["WGS84"])
      end
      it "should have a scale" do
        expect(subject.scale).to eq(["1:20000"])
      end
      it "should have a point" do
        expect(subject.point).to eq(["29.67459,-82.37873"])
      end

    end
  end
end
