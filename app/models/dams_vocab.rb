class DamsVocab < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsVocabDatastream 
  delegate_to "damsMetadata", [:description]
end
