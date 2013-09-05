class DamsProvenanceCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsProvenanceCollectionDatastream 
  delegate_to "damsMetadata", [:provenanceCollectionPart, :part_node, :provenanceCollectionPartURI, :damsObjectURI, :relatedResourceType, :relatedResourceDescription, :relatedResourceUri,:languageURI, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue, :responsibilityNoteValue, :responsibilityNoteType, :responsibilityNoteDisplayLabel, :citationNoteValue, :citationNoteType, :citationNoteDisplayLabel, :noteValue, :noteType, :noteDisplayLabel, :relationshipName,  :title, :titleValue, :subtitle, :titlePartName, :titlePartNumber, :titleNonSort,:typeOfResource, :date, :dateValue, :beginDate, :endDate,:dateType,:dateEncoding,:component, :file, :relatedResource, :language, :unit, :note, :sourceCapture, :subjectValue, :subjectURI, :unitURI, :subjectType, :subjectTypeValue, :simpleSubjectURI,:relationshipRoleURI, :relationshipNameURI, :relationshipNameType, :relationshipNameValue, :object, :temporal, :builtWorkPlace, :culturalContext, :function, :genreForm, :geographic, :iconography, :occupation, :scientificName, :stylePeriod, :technique, :name, :conferenceName, :corporateName, :familyName, :personalName, :topic, :subject, :nameType, :nameTypeValue, :nameURI]

 def provenanceCollectionParts
    damsMetadata.load_provenanceCollectionParts damsMetadata.provenanceCollectionPart
  end

 def languages
    damsMetadata.load_languages damsMetadata.language
  end

  def collections
    damsMetadata.load_collection damsMetadata.collection,damsMetadata.assembledCollection,damsMetadata.provenanceCollection,damsMetadata.provenanceCollectionPart
  end

  def complexSubjects
    damsMetadata.load_complexSubjects damsMetadata.subject
  end


  
end
