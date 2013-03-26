class DamsResourceDatastream < ActiveFedora::RdfxmlRDFDatastream

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    super
  end


  ## Title #####################################################################

  def subtitle
    self.title.first ? self.title.first.subtitle : []
  end
  def subtitle=(val)
    if self.title == nil
      self.title = []
    end
    self.title.build.subtitle = val
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
    

  ## Date ######################################################################
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
  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    date.build if date[0] == nil
    date[0].value = val
  end

  ## Language ##################################################################
  def load_languages
    load_languages(language)
  end
  def load_languages(language)
    languages = []
    language.values.each do |lang|
      if lang.value.first != nil && lang.code.first != nil
        # use inline data if available
        languages << lang
      elsif lang.pid != nil
        # load external records
        languages << DamsLanguage.find(lang.pid)
      end
    end
    languages
  end
  # tmp lang class
  class Language
    include ActiveFedora::RdfObject
    rdf_type DAMS.Language

    map_predicates do |map|
      map.code(:in => DAMS, :to => 'code')
      map.value(:in => RDF, :to => 'value')
      map.valueURI(:in => DAMS, :to => 'valueURI')
      map.vocab(:in => DAMS, :to => 'vocabulary', :class_name => 'DamsVocabulary')
    end
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    def pid
      rdf_subject.to_s.gsub(/.*\//,'')
    end
  end
  # end tmp lang class


  ## Note ######################################################################


  def scopeContentNoteType
    scopeContentNote.first ? scopeContentNote.first.type : []
  end
  def scopeContentNoteType=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.type = val
  end
  def scopeContentNoteDisplayLabel
    scopeContentNote.first ? scopeContentNote.first.displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.displayLabel = val
  end
  def scopeContentNoteValue
    scopeContentNote.first ? scopeContentNote.first.value : []
  end
  def scopeContentNoteValue=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.value = val
  end

  ## Subject ###################################################################

  # MADS complex subjects
  def load_complexSubjects
    loadComplexSubjects(complexSubject)
  end
  def load_complexSubjects(complexSubject)
	loadObjects complexSubject,MadsComplexSubject
  end

  # MADS simple subjects + extensions (VRA, etc.)
  def load_builtWorkPlaces
    load_builtWorkPlaces(builtWorkPlace)
  end
  def load_builtWorkPlaces(builtWorkPlace)
	loadObjects builtWorkPlace,DamsBuiltWorkPlace
  end
  def load_culturalContexts
    load_culturalContexts(culturalContext)
  end
  def load_culturalContexts(culturalContext)
	loadObjects culturalContext,DamsCulturalContext
  end
  def load_functions
    load_functions(function)
  end
  def load_functions(function)
	loadObjects function,DamsFunction
  end
  def load_genreForms
    load_genreForms(genreForm)
  end
  def load_genreForms(genreForm)
	loadObjects genreForm,MadsGenreForm
  end
  def load_geographics
    load_geographics(geographic)
  end
  def load_geographics(geographic)
	loadObjects geographic,MadsGeographic
  end
  def load_iconographies
    load_iconographies(iconography)
  end
  def load_iconographies(iconography)
    loadObjects iconography,DamsIconography
  end
  def load_occupations
    load_occupations(occupation)
  end
  def load_occupations(occupation)
	loadObjects occupation,MadsOccupation
  end
  def load_scientificNames
    load_scientificNames(scientificName)
  end
  def load_scientificNames(scientificName)
	loadObjects scientificName,DamsScientificName
  end
  def load_stylePeriods
    load_stylePeriods(stylePeriod)
  end
  def load_stylePeriods(stylePeriod)
	loadObjects stylePeriod,DamsStylePeriod
  end
  def load_techniques
    load_techniques(technique)
  end
  def load_techniques(technique)
	loadObjects technique,DamsTechnique
  end
  def load_temporals
    load_temporals( temporal )
  end
  def load_temporals( temporal )
	loadObjects temporal,MadsTemporal
  end
  def load_topics
    load_topics(topic)
  end
  def load_topics(topic)
	loadObjects topic,MadsTopic
  end

  # MADS names
  def load_names
    load_names(name)
  end
  def load_names(name)
	loadObjects name,MadsName
  end
  def load_conferenceNames
    load_conferenceNames(conferenceName)
  end
  def load_conferenceNames(conferenceName)
	loadObjects conferenceName,MadsConferenceName
  end
  def load_corporateNames
    load_corporateNames(corporateName)
  end
  def load_corporateNames(corporateName)
	loadObjects corporateName,MadsCorporateName
  end
  def load_familyNames
    load_familyNames(familyName)
  end
  def load_familyNames(familyName)
	loadObjects familyName,MadsFamilyName
  end
  def load_personalNames
    load_personalNames(personalName)
  end
  def load_personalNames(personalName)
	loadObjects personalName,MadsPersonalName
  end

  ## Event #####################################################################
  def load_events
    load_events(event)
  end
  def load_events(event)
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


  ## helpers ###################################################################

  # helper method for recursing over component hierarchy
  def find_children(p)
    kids = @parents[p]
    if kids != nil && kids.length > 0

      # replace children with nested hashes recursively
      for i in 0 .. kids.length
        cid = kids[i]
        if @parents[cid] != nil && @parents[cid].length > 0
          grandkids = find_children(cid)
          kids[i] = {cid => grandkids}
        end
      end
    end
    kids
  end

  # helper method to load external classes
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

  ## Solr ######################################################################
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

          Solrizer.insert_field(solr_doc, fieldName, obj.name)

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

  def insertComplexSubjectFields (solr_doc, fieldName, objects)
    if objects != nil
      n = 0
      objects.each do |obj|
          n += 1
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", obj.pid)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_name", obj.name)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_authority", obj.authority)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_valueURI", obj.valueURI.first.to_s)

          Solrizer.insert_field(solr_doc, fieldName, obj.name)

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

  def insertNoteFields (solr_doc, fieldName, objects)
    n = 0
    objects.map do |no|
      n += 1
      note_json = {}
      note_obj = nil
      if (no.external?)
        note_obj = no.load
 		Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", note_obj.pid)
        note_json[:id] = note_obj.pid.first
      else
        note_obj = no
      end

      Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_type", note_obj.type)
      Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_value", note_obj.value)
      Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_displayLabel", note_obj.displayLabel)      	
      note_json.merge!( :type => note_obj.type.first.to_s,
                       :value => note_obj.value.first.to_s,
                :displayLabel => note_obj.displayLabel.first.to_s )
      Solrizer.insert_field(solr_doc, "#{fieldName}_json", note_json.to_json )
    end

  end
  def insertDateFields (solr_doc, cid, dates)
    n = 0
    dates.map do |date|
      n += 1
      if cid != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_beginDate", date.beginDate)
        Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_endDate", date.endDate)
        Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_date", date.value)
        date_json = {:beginDate=>date.beginDate.first.to_s, :endDate=>date.endDate.first.to_s, :value=>date.value.first.to_s}
        Solrizer.insert_field(solr_doc, "component_#{cid}_date_json", date_json.to_json)
      else
        Solrizer.insert_field(solr_doc, "date_#{n}_beginDate", date.beginDate)
        Solrizer.insert_field(solr_doc, "date_#{n}_endDate", date.endDate)
        Solrizer.insert_field(solr_doc, "date_#{n}_value", date.value)
        date_json = {:beginDate=>date.beginDate.first.to_s, :endDate=>date.endDate.first.to_s, :value=>date.value.first.to_s}
        Solrizer.insert_field(solr_doc, "date_json", date_json.to_json)
      end
    end
  end
  def insertRelationshipFields ( solr_doc, prefix, relationships )
    names = []
    rels = []
    relationships.map do |relationship|
      rel = relationship.load
      rel_json = {}
      if ( rel != nil )
        rel_json[ :name ] = rel.name.first.to_s
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
      if ( relRole != nil )
        begin
          rel_json[ :role ] = relRole.value
          Solrizer.insert_field(solr_doc, "#{prefix}role", relRole.value )
          Solrizer.insert_field(solr_doc, "#{prefix}role_code", relRole.code )
          Solrizer.insert_field(solr_doc, "#{prefix}role_valueURI", relRole.valueURI.first.to_s )
        rescue
        end
      end
      rels << rel_json
    end
    names.sort.each do |n|
      Solrizer.insert_field(solr_doc, "#{prefix}name", n )
    end
    rels.sort{ |a,b| a[:name] <=> b[:name] }.each do |rel|
      Solrizer.insert_field( solr_doc, "#{prefix}relationship_json", rel.to_json )
    end
  end
  def insertTitleFields ( solr_doc, cid, titles )
    n = 0
    titles.map do |t|
      n += 1
      if cid != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_title", t.value)
        Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_subtitle", t.subtitle)
        title_json = {:type=>t.type.first.to_s, :value=>t.value.first.to_s, :subtitle=>t.subtitle.first.to_s}
        Solrizer.insert_field(solr_doc, "component_#{cid}_title_json", title_json.to_json)
      else
        Solrizer.insert_field(solr_doc, "title_#{n}_type", t.type)
        Solrizer.insert_field(solr_doc, "title_#{n}_subtitle", t.subtitle)
        Solrizer.insert_field(solr_doc, "title_#{n}_value", t.value)
        Solrizer.insert_field(solr_doc, "title", t.value)
        title_json = {:type=>t.type.first.to_s, :value=>t.value.first.to_s, :subtitle=>t.subtitle.first.to_s}
        Solrizer.insert_field(solr_doc, "title_json", title_json.to_json)
      end
    end
  end
  def insertLanguageFields ( solr_doc, field, languages )
    langs = load_languages languages
    if langs != nil
      n = 0
      langs.map.each do |lang|
        n += 1

        Solrizer.insert_field(solr_doc, "#{field}_#{n}_id", lang.pid)
        Solrizer.insert_field(solr_doc, "#{field}_#{n}_code", lang.code)
        Solrizer.insert_field(solr_doc, "#{field}_#{n}_value", lang.value)
        Solrizer.insert_field(solr_doc, "#{field}_#{n}_valueURI", lang.valueURI.first.to_s)

        Solrizer.insert_field(solr_doc, field, lang.value)
      end
    end
  end
  def insertRelatedResourceFields ( solr_doc, prefix, relatedResource )

    # relatedResource
    n = 0
    relatedResource.map do |resource|
      n += 1
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_type", resource.type)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_uri", resource.uri)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_description", resource.description)

      related_json = {:type=>resource.type.first.to_s, :uri=>resource.uri.first.to_s, :description=>resource.description.first.to_s}
      Solrizer.insert_field(solr_doc, "related_resource_json", related_json.to_json)
    end
  end
  def insertEventFields ( solr_doc, prefix, event )
    events = load_events event
    if events != nil
      n = 0
      events.each do |e|
        n += 1
        Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_id", e.pid)
        Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_type", e.type)
        Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_eventDate", e.eventDate)
        Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_outcome", e.outcome)
        rels = []
        e.relationship.map do |relationship|
	      rel = relationship.load
          rel_json = {}
	      if (rel != nil)
	         Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_name", rel.name)
             rel_json[:name] = rel.name.first.to_s
	      end 
	      relRole = relationship.loadRole
	      if (relRole != nil)
	         Solrizer.insert_field(solr_doc, "#{prefix}event_#{n}_role", relRole.value)
             rel_json[:role] = relRole.value.first.to_s
	      end  
          rels << rel_json
	    end    

        event_json = { :pid=>e.pid, :type=>e.type.first.to_s, :date=>e.eventDate.first.to_s, :outcome=>e.outcome.first.to_s, :relationship=>rels }
        Solrizer.insert_field(solr_doc, "#{prefix}event_json", event_json.to_json)
      end
    end
  end

  # field types
  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)

    # title
    insertTitleFields solr_doc, nil, title

    # date
    insertDateFields solr_doc, nil, date

    # relationship
    insertRelationshipFields solr_doc, "", relationship

    # language
    insertLanguageFields solr_doc, "language", language

    # note
    insertNoteFields solr_doc, 'note',note
    insertNoteFields solr_doc, 'custodialResponsibilityNote',custodialResponsibilityNote
    insertNoteFields solr_doc, 'preferredCitationNote',preferredCitationNote
    insertNoteFields solr_doc, 'scopeContentNote',scopeContentNote

    # subject - old
    subject.map do |sn|
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
      Solrizer.insert_field(solr_doc, 'subject_topic', subject_value,facetable)
    end

    # subject - complex
    insertComplexSubjectFields solr_doc, 'complexSubject', load_complexSubjects(complexSubject)

    # subject - simple
    insertFields solr_doc, 'builtWorkPlace', load_builtWorkPlaces(builtWorkPlace)
    insertFields solr_doc, 'culturalContext', load_culturalContexts(culturalContext)
    insertFields solr_doc, 'function', load_functions(function)
    insertFields solr_doc, 'genreForm', load_genreForms(genreForm)
    insertFields solr_doc, 'geographic', load_geographics(geographic)
    insertFields solr_doc, 'iconography', load_iconographies(iconography)
    insertFields solr_doc, 'occupation', load_occupations(occupation)
    insertFields solr_doc, 'scientificName', load_scientificNames(scientificName)
    insertFields solr_doc, 'stylePeriod', load_stylePeriods(stylePeriod)
    insertFields solr_doc, 'technique', load_techniques(technique)
    insertFields solr_doc, 'temporal', load_temporals(temporal)
    insertFields solr_doc, 'topic', load_topics(topic)

    # subject - names
    insertFields solr_doc, 'name', load_names(name)
    insertFields solr_doc, 'conferenceName', load_conferenceNames(conferenceName)
    insertFields solr_doc, 'corporateName', load_corporateNames(corporateName)
    insertFields solr_doc, 'familyName', load_familyNames(familyName)
    insertFields solr_doc, 'personalName', load_personalNames(personalName)

    insertRelatedResourceFields solr_doc, "", relatedResource


    # event
    insertEventFields solr_doc, "", event

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
