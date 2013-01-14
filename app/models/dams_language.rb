class DamsLanguage < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsMetadata", :type=> DamsLanguageDatastream
 
  delegate_to 'damsMetadata', [:code, :language, :valueURI, :vocabularyId], :unique=>"true"


#  belongs_to :dams_object, :property => :is_part_of

end
