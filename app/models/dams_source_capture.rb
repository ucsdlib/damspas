class DamsSourceCapture < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsSourceCaptureDatastream 
  has_attributes :scannerManufacturer, :sourceType, :scannerModelName, :imageProducer, :scanningSoftwareVersion, :scanningSoftware, :captureSource, datastream: :damsMetadata, multiple: true
end
