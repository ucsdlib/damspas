class DamsAssembledCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsAssembledCollectionDatastream 
  delegate_to "damsMetadata", [:title, :titleValue, :subtitle, :date, :subject, :note, :scopeContentNote, :preferredCitationNote, :custodialResponsibilityNote, :relatedResource, :dateValue, :beginDate, :endDate, :noteType, :noteValue, :noteDisplayLabel, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue, :preferredCitationNoteValue, :preferredCitationNoteDisplayLabel, :preferredCitationNoteType ]
end
