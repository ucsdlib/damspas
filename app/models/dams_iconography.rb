class DamsIconography < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsIconographyDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList, :elementValue]
  
end
