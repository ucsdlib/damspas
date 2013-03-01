class DamsScientificName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScientificNameDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
