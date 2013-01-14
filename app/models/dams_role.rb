class DamsRole < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsMetadata", :type=> DamsRoleDatastream
 
  delegate_to 'damsMetadata', [:code, :value, :valueURI, :vocabularyId], :unique=>"true"



end
