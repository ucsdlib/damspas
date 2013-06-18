class MadsOccupation < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsOccupationDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority]
  
end
