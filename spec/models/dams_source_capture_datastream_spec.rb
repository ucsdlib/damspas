require 'spec_helper'

describe DamsSourceCaptureDatastream do

  describe "a source capture model" do

    describe "instance populated in-memory" do

      subject { DamsSourceCaptureDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXX24")
      end

      it "should have a scannerManufacturer" do
        subject.scannerManufacturer = "Epson"
        expect(subject.scannerManufacturer).to eq(["Epson"])
      end

      it "should have a sourceType" do
        subject.sourceType = "transmission scanner"
        expect(subject.sourceType).to eq(["transmission scanner"])
      end

      it "should have a scannerModelName" do
        subject.scannerModelName = "Expression 1600"
        expect(subject.scannerModelName).to eq(["Expression 1600"])
      end

      it "should have a imageProducer" do
        subject.imageProducer = "Luna Imaging, Inc."
        expect(subject.imageProducer).to eq(["Luna Imaging, Inc."])
      end
 
      it "should have a scanningSoftwareVersion" do
        subject.scanningSoftwareVersion = "2.10E"
        expect(subject.scanningSoftwareVersion).to eq(["2.10E"])
      end

      it "should have a scanningSoftware" do
        subject.scanningSoftware = "Epson Twain Pro"
        expect(subject.scanningSoftware).to eq(["Epson Twain Pro"])
      end

      it "should have a captureSource" do
        subject.captureSource = "B&W negative , 2 1/2 x 2 1/2"
        expect(subject.captureSource).to eq(["B&W negative , 2 1/2 x 2 1/2"])
      end
           
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsSourceCaptureDatastream.new(double('inner object', :pid=>'xz49494949', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsSourceCapture.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xz49494949")
      end

 	  it "should have a scannerManufacturer" do
        expect(subject.scannerManufacturer).to eq(["Epson"])
      end

      it "should have a sourceType" do
        expect(subject.sourceType).to eq(["transmission scanner"])
      end

      it "should have a scannerModelName" do
        expect(subject.scannerModelName).to eq(["Expression 1600"])
      end

      it "should have a imageProducer" do
        expect(subject.imageProducer).to eq(["Luna Imaging, Inc."])
      end
 
      it "should have a scanningSoftwareVersion" do
        expect(subject.scanningSoftwareVersion).to eq(["2.10E"])
      end

      it "should have a scanningSoftware" do
        expect(subject.scanningSoftware).to eq(["Epson Twain Pro"])
      end

      it "should have a captureSource" do
        expect(subject.captureSource).to eq(["B&W negative , 2 1/2 x 2 1/2"])
      end 

    end
  end
end
