class MadsFamilyName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsFamilyNameDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
