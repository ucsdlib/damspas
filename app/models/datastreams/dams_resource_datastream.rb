class DamsResourceDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    super
  end

  ## Language ##################################################################
  def load_languages
    load_languages(language)
  end
  def load_languages(language)
    languages = []
    language.each do |lang|
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
      begin
	      if !e.outcome.first.nil? && e.outcome.first != ""
	        # use inline data if available
	        events << e
	      elsif e.pid != nil
	        events << DamsDAMSEvent.find(e.pid)
	      end
 	  rescue Exception => e
          puts e.to_s
          e.backtrace.each do |line|
            puts line
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
      if (name_pid != nil && name_pid != "" && !(name_pid.include? 'Internal'))
      	objects << className.find(name_pid)
      elsif name.name.first.nil? && name.pid != nil    
        objects << className.find(name.pid)      
      else 
      	objects << name
       end
    end
  	return objects
  end

  ## Solr ######################################################################
  def insertFields (solr_doc, fieldName, objects)
    if objects != nil
      objects.each do |obj|
        Solrizer.insert_field(solr_doc, fieldName, obj.name)
        Solrizer.insert_field(solr_doc, "fulltext", obj.name)
      end
    end
  end
  def insertFacets (solr_doc, fieldName, objects)
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    if objects != nil
      objects.each do |obj|
        Solrizer.insert_field(solr_doc, fieldName, obj.name,facetable)
      end
    end
  end

  def insertComplexSubjectFields (solr_doc, fieldName, objects)
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    if objects != nil
      objects.each do |obj|
          Solrizer.insert_field(solr_doc, fieldName, obj.name)
          Solrizer.insert_field(solr_doc, "subject_topic", obj.name, facetable)
          Solrizer.insert_field(solr_doc, "fulltext", obj.name)
      end
    end
  end

  def insertNoteFields (solr_doc, fieldName, objects)
    objects.map do |no|
      note_json = {}
      note_obj = nil
      note_uri = no.to_s
      note_pid = note_uri.gsub(/.*\//,'')     
	  if no.value.first.nil? && no.pid != nil
        note_obj = no.load
        note_json[:id] = note_obj.pid.first      
      else 
      	note_obj = no
      end
        
      note_json.merge!( :type => note_obj.type.first.to_s,
                       :value => note_obj.value.first.to_s,
                :displayLabel => note_obj.displayLabel.first.to_s )
      Solrizer.insert_field(solr_doc, "#{fieldName}_json", note_json.to_json )

      # retrieval
      Solrizer.insert_field(solr_doc, "#{fieldName}", note_obj.value )
      Solrizer.insert_field(solr_doc, "note", note_obj.value )
      Solrizer.insert_field(solr_doc, "fulltext", note_obj.value)
    end
  end
  def insertDateFields (solr_doc, cid, dates)
    dates.map do |date|
      # display
      if cid != nil
        date_json = {:beginDate=>date.beginDate.first.to_s, :endDate=>date.endDate.first.to_s, :value=>date.value.first.to_s}
        Solrizer.insert_field(solr_doc, "component_#{cid}_date_json", date_json.to_json)
      else
        date_json = {:beginDate=>date.beginDate.first.to_s, :endDate=>date.endDate.first.to_s, :value=>date.value.first.to_s}
        Solrizer.insert_field(solr_doc, "date_json", date_json.to_json)
      end

      # retrieval
      Solrizer.insert_field(solr_doc, "date", date.value.first)
      Solrizer.insert_field(solr_doc, "date", date.beginDate.first)
      Solrizer.insert_field(solr_doc, "date", date.endDate.first)
      Solrizer.insert_field(solr_doc, "fulltext", date.value)
      Solrizer.insert_field(solr_doc, "fulltext", date.beginDate)
      Solrizer.insert_field(solr_doc, "fulltext", date.endDate)
    end
  end
  def insertRelationshipFields ( solr_doc, prefix, relationships )

    # build map: role => [name1,name2]
    rels = {}
    relationships.map do |relationship|
      obj = relationship.name.first.to_s      

 	  rel = relationship
	    if !rel.corporateName.first.nil?
	      rel = rel.corporateName
	    elsif !rel.personalName.first.nil?
	      rel = rel.personalName    
		elsif !rel.name.first.nil?
	      rel = rel.name    
	      if rel.first.name.first.nil?
	      	rel = relationship.load  
	      end
	    end
      if ( rel != nil )
        if(rel.to_s.include? 'Internal')
        	name = rel.first.name.first.to_s
        	Solrizer.insert_field(solr_doc, "fulltext", rel.first.name)
        else
        	name = rel.name.first.to_s
        	Solrizer.insert_field(solr_doc, "fulltext", rel.name)
		end
		
        # retrieval
        Solrizer.insert_field( solr_doc, "name", name )
        
        
		relRole = relationship.role.first.value.first.to_s
        # display     
        
        if !relRole.nil? && relRole != ''
        	roleValue = relRole
		else 
		  role = relationship.loadRole
		  if role != nil
		  	roleValue = role.value.first.to_s
		  end
		end
		  if rels[roleValue] == nil
		    rels[roleValue] = [name]
		  else
		    rels[roleValue] << name
		  end		
      end
    end

    # sort names
    rels.each_key do |role|
      rels[role] = rels[role].sort
    end

    # add to solr
    Solrizer.insert_field( solr_doc, "#{prefix}relationship_json", rels.to_json )
  end
  def insertTitleFields ( solr_doc, cid, titles )
    titles.map do |t|
      # display
      if cid != nil
        title_json = {:type=>t.type.first.to_s, :value=>t.value.first.to_s, :subtitle=>t.subtitle.first.to_s}
        Solrizer.insert_field(solr_doc, "component_#{cid}_title_json", title_json.to_json)
      else
        title_json = {:type=>t.type.first.to_s, :value=>t.value.first.to_s, :subtitle=>t.subtitle.first.to_s}
        Solrizer.insert_field(solr_doc, "title_json", title_json.to_json)
      end

      # retrieval
      Solrizer.insert_field(solr_doc, "title", t.value.first)
      Solrizer.insert_field(solr_doc, "title", t.subtitle.first)
      Solrizer.insert_field(solr_doc, "fulltext", t.value)
      Solrizer.insert_field(solr_doc, "fulltext", t.subtitle)
    end
  end
  def insertLanguageFields ( solr_doc, field, languages )
    langs = load_languages languages
    if langs != nil
      n = 0
      langs.map.each do |lang|
        n += 1

        Solrizer.insert_field(solr_doc, field, lang.value)
        Solrizer.insert_field(solr_doc, "fulltext", lang.value)
      end
    end
  end
  def insertRelatedResourceFields ( solr_doc, prefix, relatedResource )

    # relatedResource
    n = 0
    relatedResource.map do |resource|
      n += 1
      related_json = {:type=>resource.type.first.to_s, :uri=>resource.uri.first.to_s, :description=>resource.description.first.to_s}
      Solrizer.insert_field(solr_doc, "related_resource_json", related_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", resource.uri)
      Solrizer.insert_field(solr_doc, "fulltext", resource.type)
      Solrizer.insert_field(solr_doc, "fulltext", resource.description)
    end
  end
  def events_to_json( event )
    event_array = []
    events = load_events event
    if events != nil
      n = 0
      events.each do |e|
        n += 1
        rels = []
                     
        e.relationship.map do |relationship|
	      obj = relationship.name.first.to_s      

	 	  rel = relationship
		    if !rel.corporateName.first.nil?
		      rel = rel.corporateName
		    elsif !rel.personalName.first.nil?
		      rel = rel.personalName    
			elsif !rel.name.first.nil?
		      rel = rel.name    
		      if rel.first.name.first.nil?
		      	rel = relationship.load  
		      end
		    end
          rel_json = {}
	      if (rel != nil)
			 if(rel.to_s.include? 'Internal')
	        	name = rel.first.name.first.to_s			        
	         else
	        	name = rel.name.first.to_s			        	
			 end	      
             rel_json[:name] = name
          else
            if !relationship.name.first.nil? && !relationship.name.first.pid.nil? && (relationship.name.first.pid.include? 'dams:')
				rel_json[:name] = relationship.name.first.pid		
			end	     
	      end 
	      #relRole = relationship.loadRole
		  relRole = relationship.role.first.value.first.to_s
	        # display     
	        
	        if !relRole.nil? && relRole != ''
	        	roleValue = relRole
			else 
			  role = relationship.loadRole
			  if role != nil
			  	roleValue = role.value.first.to_s
			  end
			end	      
	      if (roleValue != nil)
             rel_json[:role] = roleValue
          else
			if !relationship.role.first.nil? && !relationship.role.first.pid.nil? && (relationship.role.first.pid.include? 'dams:')
				rel_json[:role] = relationship.role.first.pid		
			end	           
	      end  
          rels << rel_json
	    end    

        event_array << { :pid=>e.pid, :type=>e.type.first.to_s, :date=>e.eventDate.first.to_s, :outcome=>e.outcome.first.to_s, :relationship=>rels }
      end
    end
    event_array
  end
  def insertEventFields ( solr_doc, prefix, event )
    event_array = events_to_json event
    event_array.each do |e|
      Solrizer.insert_field(solr_doc, "#{prefix}event_json", e.to_json)
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
      #subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      if sn != nil && sn.name.first.nil? && sn.pid != nil    
        subject_value = sn.load.name      
      else 
      	subject_value = sn.name
      end   
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
      Solrizer.insert_field(solr_doc, 'fulltext', subject_value)
      Solrizer.insert_field(solr_doc, 'subject_topic', subject_value, facetable)
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
    insertFacets solr_doc, 'subject_topic', load_topics(topic)

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
