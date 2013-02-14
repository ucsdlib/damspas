class DamsProvenanceCollectionPart < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsProvenanceCollectionPartDatastream 
  delegate_to "damsMetadata", [:title, :date, :subject, :note, :scopeContentNote, :relatedResource, :titleValue, :titleType, :dateValue, :beginDate, :endDate, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue]
end
