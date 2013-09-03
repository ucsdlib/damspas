class DamsStatute < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStatuteDatastream
  delegate_to "damsMetadata", [:citation,:jurisdiction,:note, :permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate,
  							   :permission_node, :permission_node_attributes, :restriction_node, :restriction_node_attributes ]
end
