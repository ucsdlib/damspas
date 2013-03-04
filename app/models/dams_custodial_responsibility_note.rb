class DamsCustodialResponsibilityNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCustodialResponsibilityNoteDatastream 
  delegate_to "damsMetadata", [:value, :type, :displayLabel]  
end
