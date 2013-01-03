class DamsLanguage < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsLanguage", :type=> DamsLanguageDatastream
#  has_metadata :name => "damsVocabLang", :type=> DamsVocabLangDatastream
 
  delegate_to 'damsLanguage', [:code, :language, :valueURI], :unique=>"true"

#  delegate_to 'damsVocabLang', [:vocabDesc], :unique=>"true"

#  belongs_to :dams_object, :property => :is_part_of

end
