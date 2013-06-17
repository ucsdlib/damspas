class MadsAuthority < ActiveFedora::Base
  include ActiveFedora::RdfObject
  has_metadata 'damsMetadata', :type => MadsAuthorityDatastream
  delegate_to 'damsMetadata', [ :code, :name, :description, :scheme, :externalAuthority ]
end
