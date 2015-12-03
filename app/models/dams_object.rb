class DamsObject < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Hydra::ModelMethods
  has_metadata 'damsMetadata', :type => DamsObjectDatastream
  has_attributes :assembledCollection_attributes,
  	:assembledCollection,
    :assembledCollectionURI, 
    :beginDate,
    :builtWorkPlace_attributes,
    :builtWorkPlace,
    :cartographics_attributes,
    :cartographics,
    :cartographicLine,
    :cartographicPoint,
    :cartographicPolygon,
    :cartographicProjection,
    :cartographicRefSystem,
    :cartographicScale,
    :complexSubject_attributes,
    :complexSubject,
    :component_attributes,
    :component,
    :conferenceName_attributes,
    :conferenceName,
    :copyright_attributes,
    :copyrightURI,
    :copyright,
    :corporateName_attributes,
    :corporateName,
    :creatorURI,
    :culturalContext_attributes,
    :culturalContext,
    :custodialResponsibilityNote,
    :custodialResponsibilityNote_attributes,
    :date_attributes,
    :date,
    :dateValue,
    :endDate,
    :event,
    :familyName_attributes, 
    :familyName,
    :file_attributes,
    :file,
    :function_attributes,
    :function,
    :genreForm_attributes,
    :genreForm,
    :geographic_attributes,
    :geographic,
    :iconography_attributes,
    :iconography,    
    :lithology_attributes,
    :lithology,
    :series_attributes,
    :series,
    :cruise_attributes,
    :cruise,
    :language_attributes,
    :language,
    :languageURI,
    :license_attributes, 
    :license,
    :licenseURI,
    :name_attributes,
    :name,
    :nameType,
    :nameURI,
    :note_attributes,
    :note,
    :noteDisplayLabel, 
    :noteType, 
    :occupation_attributes, 
    :occupation,
    :otherRights_attributes,
    :otherRights, 
    :otherRightsURI,
    :personalName_attributes,
    :personalName,
    :preferredCitationNote,
    :preferredCitationNote_attributes,
    :relatedResource_attributes,
    :relatedResource,
    :relatedResourceDescription, 
    :relatedResourceType, 
    :relatedResourceUri,
    :relResourceURI,
    :relationship_attributes,
    :relationship,
    :relationshipNameType, 
    :relationshipNameURI, 
    :relationshipRoleURI,
    :rightsHolderCorporate_attributes,
    :rightsHolderCorporate,
    :rightsHolderPersonal_attributes,
    :rightsHolderPersonal,
    :rightsHolderConference_attributes,
    :rightsHolderConference,
    :rightsHolderFamily_attributes,
    :rightsHolderFamily,        
    :rightsHolderURI,
    :rightsHolderName_attributes,
    :rightsHolderName,
    :rightsHolderType,
    :rightsHolder,
    :scientificName_attributes,
    :scientificName,
    :scopeContentNote_attributes,
    :scopeContentNote,
    :simpleSubjectURI, 
    :sourceCapture,
    :statute_attributes,
    :statute,
    :statuteURI,
    :stylePeriod_attributes,
    :stylePeriod,
    :subject,
    :subjectType,
    :subjectURI,
    :subtitle,
    :technique_attributes,
    :technique,
    :temporal_attributes,
    :temporal,
    :title_attributes,    
    :title,
    :titleNonSort,
    :titlePartName,
    :titlePartNumber,
    :titleValue,
    :titleVariant,
    :titleTranslationVariant,
    :titleAbbreviationVariant,
    :titleAcronymVariant,
    :titleExpansionVariant,
    :topic_attributes,
    :topic,
    :typeOfResource,
    :provenanceCollection_attributes,
    :provenanceCollection,
    :provenanceCollectionPart_attributes,    
    :provenanceCollectionPart,
    :provenanceCollectionPartURI,
    :provenanceCollectionURI,
    :unit_attributes,
    :unit,
    :unitURI,
    :commonName_attributes,
    :commonName,
      datastream: :damsMetadata, multiple: true
  
  def languages
    damsMetadata.load_languages damsMetadata.language
  end
  def units
    damsMetadata.load_unit damsMetadata.unit
  end
  def collections
    damsMetadata.load_collection damsMetadata.collection,damsMetadata.assembledCollection,damsMetadata.provenanceCollection,damsMetadata.provenanceCollectionPart
  end
  def copyrights
    damsMetadata.load_copyright damsMetadata.copyright
  end
  def licenses
    damsMetadata.load_license damsMetadata.license
  end
  def statutes
    damsMetadata.load_statute damsMetadata.statute
  end
  def otherRights
    damsMetadata.load_otherRights damsMetadata.otherRights
  end
  def rightsHolders
    damsMetadata.load_rightsHolders damsMetadata.rightsHolder
  end
  def sourceCapture
    damsMetadata.component.each do |cmp|
      cmp.file.each do |f|
        if f.sourceCapture != nil
          return damsMetadata.load_sourceCapture f.sourceCapture
        end
      end
    end
    damsMetadata.file.each do |f|
      if f.sourceCapture != nil
        return damsMetadata.load_sourceCapture f.sourceCapture
      end
    end
    return nil
  end
  def iconographies
    damsMetadata.load_iconographies
  end
  def scientificNames
    damsMetadata.load_scientificNames
  end  
  def techniques
    damsMetadata.load_techniques
  end    
  def occupations
    damsMetadata.load_occupations
  end    
  def geographics
    damsMetadata.load_geographics
  end 
  def temporals
    damsMetadata.load_temporals
  end 
  def culturalContexts
    damsMetadata.load_culturalContexts
  end   
  def stylePeriods
    damsMetadata.load_stylePeriods
  end    
  def topics
    damsMetadata.load_topics
  end      
  def functions
    damsMetadata.load_functions
  end   
  def genreForms
    damsMetadata.load_genreForms
  end   
  def personalNames
    damsMetadata.load_personalNames
  end   
  def familyNames
    damsMetadata.load_familyNames
  end      
  def names
    damsMetadata.load_names
  end   
  def conferenceNames
    damsMetadata.load_conferenceNames
  end    
  def corporateNames
    damsMetadata.load_corporateNames
  end          
end
