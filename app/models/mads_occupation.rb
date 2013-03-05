class MadsOccupation < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsOccupationDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
