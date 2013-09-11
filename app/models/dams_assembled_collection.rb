class DamsAssembledCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsAssembledCollectionDatastream 
  delegate_to "damsMetadata", [:provenanceCollectionURI, :relatedResourceType, :relatedResourceDescription, :relatedResourceUri,:languageURI, :scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue,:scopeContentNote,:responsibilityNoteValue, :responsibilityNoteType, :responsibilityNoteDisplayLabel, :citationNoteValue, :citationNoteType, :citationNoteDisplayLabel, :noteValue, :noteType, :noteDisplayLabel, :relationshipName,  :title, :titleValue, :subtitle, :titlePartName, :titlePartNumber, :titleNonSort,:typeOfResource, :date, :dateValue, :beginDate, :endDate,:component, :file, :relatedResource, :language, :unit, :note, :sourceCapture, :subjectValue, :subjectURI, :unitURI, :subjectType, :subjectTypeValue, :simpleSubjectURI,:relationshipRoleURI, :relationshipNameURI, :relationshipNameType, :relationshipNameValue, :object, :temporal, :builtWorkPlace, :culturalContext, :function, :genreForm, :geographic, :iconography, :occupation, :scientificName, :stylePeriod, :technique, :name, :conferenceName, :corporateName, :familyName, :personalName, :topic, :subject, :nameType, :nameTypeValue, :nameURI, :visibility, :resource_type]

  # rights metadata
  has_metadata 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  include Hydra::ModelMixins::RightsMetadata
  
end
