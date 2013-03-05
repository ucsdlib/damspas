class MadsCorporateName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsCorporateNameDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
