class MadsScheme < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsSchemeDatastream
  delegate_to 'damsMetadata', [ :code, :name ]
end
