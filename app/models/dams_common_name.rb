class DamsCommonName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCommonNameDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :commonNameElement_attributes, :commonNameElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
