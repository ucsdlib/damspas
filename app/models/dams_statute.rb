class DamsStatute < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStatuteDatastream
  delegate_to "damsMetadata", [:citation,:jurisdiction,:note, :permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate ]
end
