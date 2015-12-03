class DamsCruise < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCruiseDatastream
  has_attributes :name, :scheme, :elementList, :externalAuthority, :cruiseElement_attributes, :cruiseElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end