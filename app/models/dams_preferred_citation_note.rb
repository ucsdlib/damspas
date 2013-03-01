class DamsPreferredCitationNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsPreferredCitationNoteDatastream 
  delegate_to "damsMetadata", [:value, :type, :displayLabel]  
end
