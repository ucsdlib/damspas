class MadsOccupation < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsOccupationDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :occupationElement_attributes, :occupationElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
