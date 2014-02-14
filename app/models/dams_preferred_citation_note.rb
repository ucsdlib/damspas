class DamsPreferredCitationNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsPreferredCitationNoteDatastream 
  has_attributes :value, :type, :displayLabel, datastream: :damsMetadata, multiple: true
end
