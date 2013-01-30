class DamsOtherRights < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsOtherRightsDatastream
  delegate_to "damsMetadata", [:basis,:note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate ]
# :decider
end
