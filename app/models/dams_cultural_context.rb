class DamsCulturalContext < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCulturalContextDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :culturalContextElement_attributes, :culturalContextElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
