class MadsGeographic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsGeographicDatastream 
  delegate_to 'damsMetadata', [:name, :scheme, :elementList, :externalAuthority, :geographicElement_attributes, :geographicElement, :scheme_attributes]
  
end
