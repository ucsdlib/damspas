class MadsGeographic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGeographicDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
