class DamsStatute < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStatuteDatastream
  has_attributes :citation,:jurisdiction,:note, :permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate, :permission_node_attributes, :restriction_node_attributes, :permission_node, :restriction_node, datastream: :damsMetadata, multiple: true
end
