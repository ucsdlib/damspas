class DamsOtherRight < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsOtherRightDatastream
  delegate_to "damsMetadata", [:basis,:note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, 
  :restrictionType, :restrictionBeginDate, :restrictionEndDate, :name, :role, :relationship, :relationship_attributes, :permission_node, :permission_node_attributes,
  :restriction_node, :restriction_node_attributes]
# :decider
end
