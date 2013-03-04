class DamsCulturalContext < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCulturalContextDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
