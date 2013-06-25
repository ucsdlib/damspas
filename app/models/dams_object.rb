class DamsObject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsObjectDatastream 
  delegate_to "damsMetadata", [:title, :titleValue, :subtitle, :typeOfResource, :date, :dateValue, :beginDate, :endDate, :subject, :topic, :component, :file, :relatedResource, :language, :unit, :note, :sourceCapture, :subjectValue, :subjectURI, :unitURI, :subjectType, :subjectTypeValue ]

  # rights metadata
  has_metadata 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  include Hydra::ModelMixins::RightsMetadata

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
