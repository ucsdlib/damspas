class MadsName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsNameDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
