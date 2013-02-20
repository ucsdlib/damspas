# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsSourceCapture do
  subject do
    DamsSourceCapture.new pid: "bb49494949"
  end
  it "should create xml" do
    subject.scannerManufacturer = "Epson"
    subject.sourceType = "transmission scanner"
    subject.scannerModelName = "Expression 1600"
    subject.imageProducer = "Luna Imaging, Inc."
    subject.scanningSoftwareVersion = "2.10E"
    subject.scanningSoftware = "Epson Twain Pro"
    subject.captureSource = "B&W negative , 2 1/2 x 2 1/2"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:SourceCapture rdf:about="http://library.ucsd.edu/ark:/20775/bb49494949">
    <dams:scannerManufacturer>Epson</dams:scannerManufacturer>
    <dams:sourceType>transmission scanner</dams:sourceType>
    <dams:scannerModelName>Expression 1600</dams:scannerModelName>
    <dams:imageProducer>Luna Imaging, Inc.</dams:imageProducer>
    <dams:scanningSoftwareVersion>2.10E</dams:scanningSoftwareVersion>
    <dams:scanningSoftware>Epson Twain Pro</dams:scanningSoftware>
    <dams:captureSource>B&amp;W negative , 2 1/2 x 2 1/2</dams:captureSource>
  </dams:SourceCapture>
</rdf:RDF>
END

    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
