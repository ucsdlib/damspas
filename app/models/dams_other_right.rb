class DamsOtherRight < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsOtherRightDatastream
  has_attributes :basis,:note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate, :name, :role, :relationship_attributes, :permission_node_attributes, :restriction_node_attributes, :relationship, :relationshipNameType, 
    :relationshipNameURI, :relationshipRoleURI,:permission_node, :restriction_node, datastream: :damsMetadata, multiple: true
# :decider
end
