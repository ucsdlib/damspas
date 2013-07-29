class DamsBuiltWorkPlace < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsBuiltWorkPlaceDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList, :elementValue]
end
