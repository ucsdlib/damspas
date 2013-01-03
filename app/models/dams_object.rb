class DamsObject < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsMetadata", :type=> DamsObjectDatastream
# has_metadata :name => "damsLanguage", :type=> DamsLanguageDatastream
# has_metadata :name => "damsVocabLang", :type=> DamsVocabLangDatastream

#  delegate :title, :to=>"titleMetadata", :unique=>"true"
  delegate_to 'damsMetadata', [:title, :arkUrl, :relatedTitle, :relatedTitleType, :relatedTitleLang, :beginDate, :endDate, :date, :languageId], :unique=>"true" 
  
#  delegate_to 'damsLanguage', [:code, :language], :unique=>"true"

#  delegate_to 'damsVocabLang', [:vocabDesc], :unique=>"true"

#   has_many :dams_languages, :property => :is_part_of

#   has_and_belongs_to_many :dams_languages, :property => :is_part_of

end
