class DamsObject < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Hydra::ModelMethods
  has_metadata 'damsMetadata', :type => DamsObjectDatastream
  has_attributes :assembledCollection,
    :assembledCollectionURI, 
    :beginDate,
    :builtWorkPlace,
    :cartographics,
    :cartographicLine,
    :cartographicPoint,
    :cartographicPolygon,
    :cartographicProjection,
    :cartographicRefSystem,
    :cartographicScale,
    :complexSubject,
    :component,
    :conferenceName,
    :copyrightURI,
    :copyright,
    :corporateName,
    :creatorURI,
    :culturalContext,
    :custodialResponsibilityNote,
    :date,
    :dateValue,
    :endDate,
    :event,
    :familyName,
    :file,
    :function,
    :genreForm,
    :geographic,
    :iconography,
    :language,
    :languageURI,
    :license,
    :licenseURI,
    :name,
    :nameType,
    :nameURI,
    :note,
    :note_attributes,
    :occupation,
    :otherRights, 
    :otherRightsURI,
    :personalName,
    :preferredCitationNote,
    :relatedResource,
    :relResourceURI,
    :relationship,
    :relationshipNameType, 
    :relationshipNameURI, 
    :relationshipRoleURI,
    :rightsHolderCorporate,
    :rightsHolderPersonal,
    :rightsHolderConference,
    :rightsHolderFamily,        
    :rightsHolderURI,
    :rightsHolderName,
    :rightsHolderType,
    :rightsHolder,
    :scientificName,
    :scopeContentNote,
    :simpleSubjectURI, 
    :sourceCapture,
    :statute,
    :statuteURI,
    :stylePeriod,
    :subject,
    :subjectType,
    :subjectURI,
    :subtitle,
    :technique,
    :temporal,
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
    :topic,
    :typeOfResource,
    :provenanceCollection,
    :provenanceCollectionPart,
    :provenanceCollectionPartURI,
    :provenanceCollectionURI,
    :unit,
    :unitURI,
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
