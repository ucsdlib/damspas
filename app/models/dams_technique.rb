class DamsTechnique < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsTechniqueDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
