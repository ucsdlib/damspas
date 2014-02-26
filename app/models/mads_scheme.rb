class MadsScheme < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsSchemeDatastream
  has_attributes  :code, :name, datastream: :damsMetadata, multiple: true
end
