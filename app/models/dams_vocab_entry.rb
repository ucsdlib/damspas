class DamsVocabEntry < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsVocabEntryDatastream 
  delegate_to "damsMetadata", [:code, :value, :valueURI, :vocabulary, :authority, :authorityURI]
end
