class DamsBuiltWorkPlace < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsBuiltWorkPlaceDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :builtWorkPlaceElement_attributes, :builtWorkPlaceElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end

