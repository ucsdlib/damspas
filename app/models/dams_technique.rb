class DamsTechnique < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsTechniqueDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList, :techniqueElement_attributes, :techniqueElement, :scheme_attributes]
  
end
