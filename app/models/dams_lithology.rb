class DamsLithology < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsLithologyDatastream
  has_attributes :name, :scheme, :elementList, :externalAuthority, :lithologyElement_attributes, :lithologyElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
