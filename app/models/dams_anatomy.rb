class DamsAnatomy < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsAnatomyDatastream
  has_attributes :name, :scheme, :elementList, :externalAuthority, :anatomyElement_attributes, :anatomyElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
