class DamsCulturalContext < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCulturalContextDatastream 
  delegate_to 'damsMetadata', [:name, :scheme, :elementList, :externalAuthority, :culturalContextElement_attributes, :culturalContextElement, :scheme_attributes]
end
