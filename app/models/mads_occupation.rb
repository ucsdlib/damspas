class MadsOccupation < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsOccupationDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :occupationElement_attributes, :occupationElement, :scheme_attributes]
  
end
