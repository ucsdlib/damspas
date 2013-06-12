class DamsProvenanceCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsProvenanceCollectionDatastream 
  delegate_to "damsMetadata", [:title, :date, :subject, :languageValue, :unit, :note, :scopeContentNote, :relatedResource, :titleValue, :titleType, :dateValue, :beginDate, :endDate, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue, :subjectValue]
  def part
    damsMetadata.load_part
  end

 
  
end
