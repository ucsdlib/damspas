class DamsRole < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsRoleDatastream 
  delegate_to "damsMetadata", [:code, :value, :valueURI, :vocabulary]
end
