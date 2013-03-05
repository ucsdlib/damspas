class MadsPersonalName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsPersonalNameDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
