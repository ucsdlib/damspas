class DamsLicense < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsLicenseDatastream
  delegate_to "damsMetadata", [:note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate,
  							   :permission_node, :permission_node_attributes, :restriction_node, :restriction_node_attributes ]
end
