class DamsVocabulary < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsVocabularyDatastream 
  delegate_to "damsMetadata", [:description]
end
