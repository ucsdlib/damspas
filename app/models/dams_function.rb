class DamsFunction < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsFunctionDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList]
  
end
