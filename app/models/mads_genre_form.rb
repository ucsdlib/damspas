class MadsGenreForm < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGenreFormDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority, :elementValue]
  
end
