class DamsVocabularyEntry < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsVocabularyEntryDatastream 
  delegate_to "damsMetadata", [:code, :value, :valueURI, :vocabulary, :authority, :authorityURI]
end
