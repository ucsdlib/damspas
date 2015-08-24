class DamsScopeContentNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScopeContentNoteDatastream 
  has_attributes :value, :type, :displayLabel, :internalOnly, datastream: :damsMetadata, multiple: true
end
