class DamsVocab < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsVocabulary", :type=> DamsVocabularyDatastream
 
  delegate_to 'damsVocabulary', [:vocabDesc], :unique=>"true"

end
