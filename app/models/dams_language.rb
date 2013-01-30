class DamsLanguage < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsLanguageDatastream 
  delegate_to "damsMetadata", [:code, :value, :valueURI, :vocabulary]
end
