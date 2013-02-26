require 'spec_helper'

describe DamsSourceCaptureDatastream do

  describe "a source capture model" do

    describe "instance populated in-memory" do

      subject { DamsSourceCaptureDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a scannerManufacturer" do
        subject.scannerManufacturer = "Epson"
        subject.scannerManufacturer.should == ["Epson"]
      end

      it "should have a sourceType" do
        subject.sourceType = "transmission scanner"
        subject.sourceType.should == ["transmission scanner"]
      end

      it "should have a scannerModelName" do
        subject.scannerModelName = "Expression 1600"
        subject.scannerModelName.should == ["Expression 1600"]
      end

      it "should have a imageProducer" do
        subject.imageProducer = "Luna Imaging, Inc."
        subject.imageProducer.should == ["Luna Imaging, Inc."]
      end
 
      it "should have a scanningSoftwareVersion" do
        subject.scanningSoftwareVersion = "2.10E"
        subject.scanningSoftwareVersion.should == ["2.10E"]
      end

      it "should have a scanningSoftware" do
        subject.scanningSoftware = "Epson Twain Pro"
        subject.scanningSoftware.should == ["Epson Twain Pro"]
      end

      it "should have a captureSource" do
        subject.captureSource = "B&W negative , 2 1/2 x 2 1/2"
        subject.captureSource.should == ["B&W negative , 2 1/2 x 2 1/2"]
      end
           
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsSourceCaptureDatastream.new(stub('inner object', :pid=>'bb49494949', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsSourceCapture.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb49494949"
      end

 	  it "should have a scannerManufacturer" do
        subject.scannerManufacturer.should == ["Epson"]
      end

      it "should have a sourceType" do
        subject.sourceType.should == ["transmission scanner"]
      end

      it "should have a scannerModelName" do
        subject.scannerModelName.should == ["Expression 1600"]
      end

      it "should have a imageProducer" do
        subject.imageProducer.should == ["Luna Imaging, Inc."]
      end
 
      it "should have a scanningSoftwareVersion" do
        subject.scanningSoftwareVersion.should == ["2.10E"]
      end

      it "should have a scanningSoftware" do
        subject.scanningSoftware.should == ["Epson Twain Pro"]
      end

      it "should have a captureSource" do
        subject.captureSource.should == ["B&W negative , 2 1/2 x 2 1/2"]
      end 

    end
  end
end
