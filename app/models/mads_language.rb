class MadsLanguage < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  has_metadata 'damsMetadata', :type => MadsLanguageDatastream 
  has_attributes :code, :name, :scheme, :elementList, :externalAuthority, :languageElement_attributes, :languageElement, :scheme_attributes, datastream: :damsMetadata, multiple: true

end
