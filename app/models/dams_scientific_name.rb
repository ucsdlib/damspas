class DamsScientificName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScientificNameDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :scientificNameElement_attributes, :scientificNameElement, :scheme_attributes]
  
end
