class DamsCollectionDatastream < ActiveFedora::RdfxmlRDFDatastream


  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    super
  end

  def titleValue
    title[0] ? title[0].value : []
  end
  def titleValue=(val)
    title.build if title[0] == nil
    title[0].value = val
  end

  def titleType
    title[0] ? title[0].type : []
  end
  def titleType=(val)
    title.build if title[0] == nil
    title[0].type = val
  end

  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    date.build if date[0] == nil
    date[0].value = val
  end

  def beginDate
    date[0] ? date[0].beginDate : []
  end
  def beginDate=(val)
    date.build if date[0] == nil
    date[0].beginDate = val
  end

  def endDate
    date[0] ? date[0].endDate : []
  end
  def endDate=(val)
    date.build if date[0] == nil
    date[0].endDate = val
  end

  def scopeContentNoteValue
    scopeContentNote[0] ? scopeContentNote[0].value : []
  end
  def scopeContentNoteValue=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].value = val
  end

  def scopeContentNoteType
    scopeContentNote[0] ? scopeContentNote[0].type : []
  end
  def scopeContentNoteType=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].type = val
  end

  def scopeContentNoteDisplayLabel
    scopeContentNote[0] ? scopeContentNote[0].displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].displayLabel = val
  end



  class Date
    include ActiveFedora::RdfObject
    rdf_type DAMS.Date
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
    end
  end

  class Subject
    include ActiveFedora::RdfObject
    rdf_type MADS.ComplexSubject
    map_predicates do |map|      
      map.authoritativeLabel(:in=> MADS)
    end

    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsSubject.find(md[1])
    end
  end
  class RelatedResource
    include ActiveFedora::RdfObject
    rdf_type DAMS.RelatedResource
    map_predicates do |map|    
      map.type(:in=> DAMS)
      map.description(:in=> DAMS)
      map.uri(:in=> DAMS)
    end
  end

  class Note
    include ActiveFedora::RdfObject
    rdf_type DAMS.Note
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsNote.find(md[1])
    end
  end

  class ScopeContentNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.ScopeContentNote
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      #puts rdf_subject
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsScopeContentNote.find(md[1])
    end
  end

  class PreferredCitationNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.PreferredCitationNote
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsPreferredCitationNote.find(md[1])
      end
    end
  end  
  
  class CustodialResponsibilityNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.CustodialResponsibilityNote
    map_predicates do |map|
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsCustodialResponsibilityNote.find(md[1])
      end
    end
  end  
  
  def load_languages
    languages = []
    language.values.each do |lang|
      lang_uri = lang.to_s
      lang_pid = lang_uri.gsub(/.*\//,'')
      if lang_pid != nil && lang_pid != ""
        languages << DamsLanguage.find(lang_pid)
      end
    end
    languages
  end

  def load_events
    events = []
    event.values.each do |e|
      event_uri = e.to_s
      event_pid = event_uri.gsub(/.*\//,'')
      if event_pid != nil && event_pid != ""
        begin
           events << DamsDAMSEvent.find(event_pid)
        rescue Exception => e
          puts e.to_s
          e.backtrace.each do |line|
            puts line
          end
        end              
      end
    end
    events
  end 

  def insertNoteFields (solr_doc, fieldName, objects)
    n = 0
    objects.map do |no| 
      n += 1
      if (no.external?)
 		Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", no.load.pid)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_type", no.load.type)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_value", no.load.value)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_displayLabel", no.load.displayLabel)      
      else
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_type", no.type)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_value", no.value)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_displayLabel", no.displayLabel)      	
      end
    end  
  
  end

  # copied from DamsObjectDatastream
  def insertComplexSubjectFields (solr_doc, fieldName, objects)
    if objects != nil
      n = 0
      objects.each do |obj|
          n += 1
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", obj.pid)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_name", obj.name)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_authority", obj.authority)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_valueURI", obj.valueURI.first.to_s)
          list = obj.componentList.first
          i = 0
          if list != nil
            while i < list.size  do
              if (list[i].class == MadsComplexSubjectDatastream::ComponentList::Topic)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_topic", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::GenreForm)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_genreForm", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Iconography)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_iconography", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::ScientificName)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_scientificName", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Technique)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_technique", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::BuiltWorkPlace)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_builtWorkPlace", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::PersonalName)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_personalName", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Geographic)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_geographic", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Temporal)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_temporal", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::CulturalContext)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_culturalContext", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::StylePeriod)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_stylePeriod", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::ConferenceName)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_conferenceName", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Function)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_function", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::CorporateName)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_corporateName", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::Occupation)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_occupation", list[i].name.first)
              elsif (list[i].class == MadsComplexSubjectDatastream::ComponentList::FamilyName)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_familyName", list[i].name.first)                                                   
              end
              i +=1
            end
          end
      end
    end
  end

  def insertFields (solr_doc, fieldName, objects)
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    if objects != nil
      n = 0
      objects.each do |obj|
          n += 1
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", obj.pid)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_name", obj.name)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_authority", obj.authority)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_valueURI", obj.valueURI.first.to_s)
          list = obj.elementList.first
          i = 0
          if list != nil
            while i < list.size  do
              if (list[i].class == MadsDatastream::List::NameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_name", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::FamilyNameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_familyName", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::DateNameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_dateName", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::TermsOfAddressNameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_termsOfAddress", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::GivenNameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_givenName", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::GenreFormElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_genreForm", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::FunctionElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_function", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::StylePeriodElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_stylePeriod", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::CulturalContextElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_culturalContext", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::TemporalElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_temporal", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::GeographicElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_geographic", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::BuiltWorkPlaceElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_builtWorkPlace", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::OccupationElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_occupation", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::TechniqueElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_technique", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::ScientificNameElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_scientificName", list[i].elementValue.first)
              elsif (list[i].class == DamsDatastream::List::IconographyElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_iconography", list[i].elementValue.first)
              elsif (list[i].class == MadsDatastream::List::TopicElement)
                Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_#{i}_topic", list[i].elementValue.first)
                Solrizer.insert_field(solr_doc, "subject_topic", list[i].elementValue.first, facetable)
              end
              i +=1
            end
          end
      end
    end
  end

  def loadObjects (object,className)
    objects = []
    object.values.each do |name|
      name_uri = name.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if name_pid != nil && name_pid != ""
        objects << className.find(name_pid)
      end
    end
    return objects
  end

  def load_iconographies
    loadObjects iconography,DamsIconography
  end

  def load_scientificNames
    loadObjects scientificName,DamsScientificName
  end

  def load_techniques
    loadObjects technique,DamsTechnique
  end

  def load_builtWorkPlaces
    loadObjects builtWorkPlace,DamsBuiltWorkPlace
  end

  def load_geographics
    loadObjects geographic,MadsGeographic
  end

  def load_temporals
    loadObjects temporal,MadsTemporal
  end

  def load_culturalContexts
    loadObjects culturalContext,DamsCulturalContext
  end

  def load_stylePeriods
    loadObjects stylePeriod,DamsStylePeriod
  end

  def load_topics
    loadObjects topic,MadsTopic
  end

  def load_functions
    loadObjects function,DamsFunction
  end

  def load_genreForms
    loadObjects genreForm,MadsGenreForm
  end

  def load_occupations
    loadObjects occupation,MadsOccupation
  end

  def load_personalNames
    loadObjects personalName,MadsPersonalName
  end

  def load_familyNames
    loadObjects familyName,MadsFamilyName
  end

  def load_names
    loadObjects name,MadsName
  end

  def load_conferenceNames
    loadObjects conferenceName,MadsConferenceName
  end

  def load_corporateNames
    loadObjects corporateName,MadsCorporateName
  end

  def load_complexSubjects
    loadObjects complexSubject,MadsComplexSubject
  end
  # copied from DamsObjectDatastream

  def to_solr (solr_doc = {})
    # need to make these support multiples too
    Solrizer.insert_field(solr_doc, 'title', title.first.value)

    singleString = Solrizer::Descriptor.new(:string, :indexed, :stored)
    Solrizer.insert_field(solr_doc, 'col_name', title.first.value, singleString)
    Solrizer.insert_field(solr_doc, 'type', 'Collection')

    n = 0
    date.map do |date|
      n += 1
      Solrizer.insert_field(solr_doc, "date_#{n}_beginDate", date.beginDate)
      Solrizer.insert_field(solr_doc, "date_#{n}_endDate", date.endDate)
      Solrizer.insert_field(solr_doc, "date_#{n}_value", date.value)
    end

    subject.map do |sn| 
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
    end
    names = []
    relationship.map do |relationship|
      rel = relationship.load
      if (rel != nil)
        #Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
        begin
          n = rel.name.first.to_s
          if not names.include?( n )
            names << n
          end
        rescue Exception => e
          puts e.to_s
          e.backtrace.each do |line|
            puts line
          end
        end
      end
      relRole = relationship.loadRole
      if ( rel != nil )
        Solrizer.insert_field(solr_doc, 'role', relationship.loadRole.value )
        Solrizer.insert_field(solr_doc, 'role_code', relationship.loadRole.code )
        Solrizer.insert_field(solr_doc, 'role_valueURI', relationship.loadRole.valueURI.first.to_s )
      end      
    end
    names.sort.each do |n|
      Solrizer.insert_field(solr_doc, 'name', n )
    end
    insertNoteFields solr_doc, 'scopeContentNote',scopeContentNote
    insertNoteFields solr_doc, 'preferredCitationNote',preferredCitationNote
    insertNoteFields solr_doc, 'custodialResponsibilityNote',custodialResponsibilityNote
    insertNoteFields solr_doc, 'note',note


    langs = load_languages
    if langs != nil
      n = 0
      langs.each do |lang|
        n += 1
        Solrizer.insert_field(solr_doc, "language_#{n}_id", lang.pid)
        Solrizer.insert_field(solr_doc, "language_#{n}_code", lang.code)
        Solrizer.insert_field(solr_doc, "language_#{n}_value", lang.value)
        Solrizer.insert_field(solr_doc, "language_#{n}_valueURI", lang.valueURI.first.to_s)
      end
    end

    events = load_events
    if events != nil
      n = 0
      events.each do |e|
        n += 1
        Solrizer.insert_field(solr_doc, "event_#{n}_id", e.pid)
        Solrizer.insert_field(solr_doc, "event_#{n}_type", e.type)
        Solrizer.insert_field(solr_doc, "event_#{n}_eventDate", e.eventDate)
        Solrizer.insert_field(solr_doc, "event_#{n}_outcome", e.outcome)
        e.relationship.map do |relationship|
	      rel = relationship.load
	      if (rel != nil)
	         Solrizer.insert_field(solr_doc, "event_#{n}_name", rel.name)
	      end 
	      relRole = relationship.loadRole
	      if (relRole != nil)
	         Solrizer.insert_field(solr_doc, "event_#{n}_role", relRole.value)
	      end  
	    end    
      end
    end
        
    n = 0
    relatedResource.map do |resource|
      n += 1
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_type", resource.type)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_uri", resource.uri)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_description", resource.description)
    end

    # copied from DamsObjectDatastream
    insertFields solr_doc, 'iconography', load_iconographies
    insertFields solr_doc, 'scientificName', load_scientificNames
    insertFields solr_doc, 'technique', load_techniques
    insertFields solr_doc, 'occupation', load_occupations
    insertFields solr_doc, 'builtWorkPlace', load_builtWorkPlaces
    insertFields solr_doc, 'geographic', load_geographics
    insertFields solr_doc, 'temporal', load_temporals
    insertFields solr_doc, 'culturalContext', load_culturalContexts
    insertFields solr_doc, 'stylePeriod', load_stylePeriods
    insertFields solr_doc, 'topic', load_topics
    insertFields solr_doc, 'function', load_functions
    insertFields solr_doc, 'genreForm', load_genreForms

    insertFields solr_doc, 'personalName', load_personalNames
    insertFields solr_doc, 'familyName', load_familyNames
    insertFields solr_doc, 'name', load_names
    insertFields solr_doc, 'conferenceName', load_conferenceNames
    insertFields solr_doc, 'corporateName', load_corporateNames
    insertComplexSubjectFields solr_doc, 'complexSubject', load_complexSubjects
    # copied from DamsObjectDatastream

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }
    return solr_doc
  end
end
