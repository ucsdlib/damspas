class DamsCopyright < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  has_metadata 'damsMetadata', :type => DamsCopyrightDatastream
  has_attributes :status,:jurisdiction,:purposeNote,:note, :beginDate, :endDate, :dateValue, :date_attributes, :date, datastream: :damsMetadata, multiple: true

end
