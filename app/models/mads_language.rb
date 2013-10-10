class MadsLanguage < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsLanguageDatastream 
  delegate_to "damsMetadata", [:code, :name, :scheme, :elementList, :externalAuthority, :languageElement_attributes, :languageElement, :scheme_attributes]

  # rights metadata
  has_metadata 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  include Hydra::ModelMixins::RightsMetadata

 # def id
 # 	damsMetadata.rdf_subject
 # end
  
  
end
