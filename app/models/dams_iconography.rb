class DamsIconography < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsIconographyDatastream
  has_attributes :name, :scheme, :elementList, :externalAuthority, :iconographyElement_attributes, :iconographyElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
