class DamsScopeContentNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsScopeContentNoteDatastream 
  delegate_to "damsMetadata", [:value, :type, :displayLabel]  
end
