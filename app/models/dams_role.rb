class DamsRole < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsRole", :type=> DamsRoleDatastream
 
  delegate_to 'damsRole', [:code, :value, :valueURI, :vocabularyId], :unique=>"true"



end
