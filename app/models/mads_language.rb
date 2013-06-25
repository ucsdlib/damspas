class MadsLanguage < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsLanguageDatastream 
  delegate_to "damsMetadata", [:name, :code, :externalAuthority, :elementList, :elementListValue , :scheme]
end
