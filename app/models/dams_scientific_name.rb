class DamsScientificName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScientificNameDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :scientificNameElement_attributes, :scientificNameElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
