class DamsRelatedResource < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  
  has_metadata 'damsMetadata', :type => DamsRelatedResourceDatastream 
  has_attributes :uri, :description, :type, datastream: :damsMetadata, multiple: true

end
