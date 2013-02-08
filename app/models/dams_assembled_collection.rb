class DamsAssembledCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsAssembledCollectionDatastream 
  delegate_to "damsMetadata", [:title, :date, :subject, :note, :scopeContentNote, :relatedResource, :titleValue, :titleType, :dateValue, :beginDate, :endDate, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue ]
end
