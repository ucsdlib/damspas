class DamsVocab < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsMetadata", :type=> DamsVocabularyDatastream
 
  delegate_to 'damsMetadata', [:vocabDesc], :unique=>"true"

end
