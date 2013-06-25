class DamsAssembledCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsAssembledCollectionDatastream 
  delegate_to "damsMetadata", [:title, :titleValue, :subtitle, :date, :subject, :note, :scopeContentNote, :relatedResource, :dateValue, :beginDate, :endDate, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue ]
end
