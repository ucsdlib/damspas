class MadsGeographic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGeographicDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :geographicElement_attributes, :geographicElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
