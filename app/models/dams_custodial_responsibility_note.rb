class DamsCustodialResponsibilityNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCustodialResponsibilityNoteDatastream 
  has_attributes :value, :type, :displayLabel, :internalOnly, datastream: :damsMetadata, multiple: true
end
