class DamsBuiltWorkPlace < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsBuiltWorkPlaceDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
