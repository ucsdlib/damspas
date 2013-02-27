class DamsNote < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsNoteDatastream 
  delegate_to "damsMetadata", [:value, :type, :displayLabel]  
end
