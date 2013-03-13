class DamsDAMSEvent < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsDAMSEventDatastream 
  delegate_to "damsMetadata", [:type, :eventDate, :outcome]
end
