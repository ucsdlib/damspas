class DamsFunction < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsFunctionDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
