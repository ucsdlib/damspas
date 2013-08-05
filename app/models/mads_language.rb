class MadsLanguage < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsLanguageDatastream 
  delegate_to "damsMetadata", [:code, :name, :scheme, :elementList, :externalAuthority, :languageElement_attributes, :languageElement, :scheme_attributes]
end
