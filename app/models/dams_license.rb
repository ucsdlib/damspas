class DamsLicense < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsLicenseDatastream
  delegate_to "damsMetadata", [:note,:uri,:permissionType, :permissionBeginDate, :permissionEndDate, :restrictionType, :restrictionBeginDate, :restrictionEndDate ]
end
