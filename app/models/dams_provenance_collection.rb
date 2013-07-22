class DamsProvenanceCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsProvenanceCollectionDatastream 
  delegate_to "damsMetadata", [:part_node, :provenanceCollectionPartURI, :damsObjectURI, :relatedResourceType, :relatedResourceDescription, :relatedResourceUri,:languageURI, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue, :noteValue, :noteType, :noteDisplayLabel, :relationshipName,  :title, :titleValue, :subtitle, :titlePartName, :titlePartNumber, :titleNonSort,:typeOfResource, :date, :dateValue, :beginDate, :endDate, :subject, :topic, :component, :file, :relatedResource, :language, :unit, :note, :sourceCapture, :subjectValue, :subjectURI, :unitURI, :subjectType, :subjectTypeValue,:relationshipRoleURI, :relationshipNameURI, :relationshipNameType, :relationshipNameValue, :object]

 def parts
    damsMetadata.load_parts damsMetadata.part_node
  end

 def languages
    damsMetadata.load_languages damsMetadata.language
  end

  

  def complexSubjects
    damsMetadata.load_complexSubjects damsMetadata.subject
  end
  
end
