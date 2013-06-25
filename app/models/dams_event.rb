class DamsEvent < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsEventDatastream 
  delegate_to "damsMetadata", [:type, :eventDate, :outcome, :relationship]
end
