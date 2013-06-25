class DamsScientificName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScientificNameDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList]
  
end
