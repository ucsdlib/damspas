class DamsSourceCapture < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsSourceCaptureDatastream 
  delegate_to "damsMetadata", [:scannerManufacturer, :sourceType, :scannerModelName, :imageProducer, :scanningSoftwareVersion, :scanningSoftware, :captureSource ]
end
