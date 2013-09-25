class DamsCopyright < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCopyrightDatastream
  delegate_to "damsMetadata", [:status,:jurisdiction,:purposeNote,:note, :beginDate, :endDate, :dateValue, :date_attributes, :date]

  # rights metadata
  has_metadata 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  include Hydra::ModelMixins::RightsMetadata

end
