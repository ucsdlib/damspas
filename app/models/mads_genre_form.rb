class MadsGenreForm < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGenreFormDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :genreFormElement_attributes, :genreFormElement, :scheme_attributes]
  
end
