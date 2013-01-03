class DamsLanguage < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsLanguage", :type=> DamsLanguageDatastream
 
  delegate_to 'damsLanguage', [:code, :language, :valueURI, :vocabularyId], :unique=>"true"


#  belongs_to :dams_object, :property => :is_part_of

end
