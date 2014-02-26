class MadsGenreForm < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGenreFormDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :genreFormElement_attributes, :genreFormElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
