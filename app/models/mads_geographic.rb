class MadsGeographic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGeographicDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority]
  
end
