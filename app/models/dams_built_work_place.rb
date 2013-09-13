class DamsBuiltWorkPlace < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsBuiltWorkPlaceDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :builtWorkPlaceElement_attributes, :builtWorkPlaceElement, :scheme_attributes]
  
end

