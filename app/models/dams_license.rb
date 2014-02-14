class DamsLicense < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsLicenseDatastream
  has_attributes :note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate, :permission_node_attributes, :restriction_node_attributes, :permission_node, :restriction_node, datastream: :damsMetadata, multiple: true
end
