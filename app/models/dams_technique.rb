class DamsTechnique < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsTechniqueDatastream 
  has_attributes :name, :scheme, :externalAuthority, :elementList, :techniqueElement_attributes, :techniqueElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
