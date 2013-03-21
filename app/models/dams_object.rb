class DamsObject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsObjectDatastream 
  delegate_to "damsMetadata", [:title, :titleType, :titleValue, :subtitle, :typeOfResource, :date, :beginDate, :endDate, :subject, :topic, :component, :file, :relatedResource ]
  def languages
    damsMetadata.load_languages
  end
  def units
    damsMetadata.load_unit
  end
  def collections
    damsMetadata.load_collection
  end
  def copyrights
    damsMetadata.load_copyright
  end
  def licenses
    damsMetadata.load_license
  end
  def statutes
    damsMetadata.load_statute
  end
  def otherRights
    damsMetadata.load_otherRights
  end
  def rightsHolders
    damsMetadata.load_rightsHolders
  end
  def source_capture
    damsMetadata.load_source_capture damsMetadata.component.first.file.first.source_capture
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
