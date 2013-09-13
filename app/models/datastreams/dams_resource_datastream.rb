class DamsResourceDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def load_collection (collection,assembledCollection,provenanceCollection,provenanceCollectionPart)
    collections = []
    [collection,assembledCollection,provenanceCollection,provenanceCollectionPart].each do |coltype|
      coltype.each do |col|
        begin
          # if we have usable metadata, use as-is
          if col.title.first != nil
            collections << col
            colfound = true
          end
        rescue
          colfound = false
        end

        if !colfound
          # if we don't, find the pid and fetch colobj from repo
          cpid = (col.class.name.include? "Collection") ? cpid = col.pid : col.to_s.gsub(/.*\//,'')
          begin
            collections << ActiveFedora::Base.find(cpid, :cast => true)
          rescue
            logger.warn "Couldn't load collection from repo: #{cpid}"
          end
        end
      end
    end
    collections
  end

 ## Language ##################################################################
  def load_languages
    load_languages(language)
  end
  def load_languages(language)
    languages = []
    begin
      language.each do |lang|
        if lang.name.first != nil && lang.code.first != nil
          # use inline data if available
          languages << lang
        elsif lang.pid != nil
          # load external records
          languages << MadsLanguage.find(lang.pid)
        end
      end
    rescue Exception => e
      puts "trapping language error"
      puts e.backtrace
    end
    languages
  end
   
  # tmp lang class
#  class Language
#    include ActiveFedora::RdfObject
#    include ActiveFedora::Rdf::DefaultNodes
#    rdf_type DAMS.Language
#
#    map_predicates do |map|
#      map.code(:in => DAMS, :to => 'code')
#      map.value(:in => RDF, :to => 'value')
#      map.valueURI(:in => DAMS, :to => 'valueURI')
#      map.vocab(:in => DAMS, :to => 'vocabulary', :class_name => 'DamsVocabulary')
#    end
#    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
#    def pid
#      rdf_subject.to_s.gsub(/.*\//,'')
#    end
#  end


 ## provenanceCollectionPart ##################################################################
  def load_provenanceCollectionParts
    load_provenanceCollectionParts(provenanceCollectionPart)
  end
  def load_provenanceCollectionParts(provenanceCollectionPart)
    provenanceCollectionParts = []
    begin
      provenanceCollectionPart.each do |part|
        if part.title.first != nil 
          # use inline data if available
          provenanceCollectionParts << part
        elsif part.pid != nil
          # load external records
          provenanceCollectionParts << DamsProvenanceCollectionPart.find(part.pid)
        end
      end
    rescue Exception => e
      puts "trapping provenanceCollectionPart error"
      puts e.backtrace
    end
    provenanceCollectionParts
  end

## provenanceCollection ##################################################################
  def load_provenanceCollections
    load_provenanceCollections(provenanceCollection)
  end
  def load_provenanceCollections(provenanceCollection)
    provenanceCollections = []
    begin
      provenanceCollection.each do |part|
        if part.title.first != nil 
          # use inline data if available
          provenanceCollections << part
        elsif part.pid != nil
          # load external records
          provenanceCollections << DamsProvenanceCollection.find(part.pid)
        end
      end
    rescue Exception => e
      puts "trapping provenanceCollection error"
      puts e.backtrace
    end
    provenanceCollections
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
    foo = genreForm.to_s
	loadObjects genreForm,MadsGenreForm
  end
  def load_geographics
    load_geographics(geographic)
  end
  def load_geographics(geographic)
    foo = geographic.to_s
	loadObjects geographic,MadsGeographic
  end
  def load_iconographies
    load_iconographies(iconography)
  end
  def load_iconographies(iconography)
    foo = iconography.to_s
    loadObjects iconography,DamsIconography
  end
  def load_occupations
    load_occupations(occupation)
  end
  def load_occupations(occupation)
    foo = occupation.to_s
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
    foo = temporal.to_s
	loadObjects temporal,MadsTemporal
  end
  def load_topics
    load_topics(topic)
  end
  def load_topics(topic)
    foo = topic.to_s
	loadObjects topic,MadsTopic
  end

  # MADS names
  def load_names
    load_names(name)
  end
  def load_names(name)
    foo = name.to_s
	loadObjects name,MadsName
  end
  def load_conferenceNames
    load_conferenceNames(conferenceName)
  end
  def load_conferenceNames(conferenceName)
    foo = conferenceName.to_s
	loadObjects conferenceName,MadsConferenceName
  end
  def load_corporateNames
    load_corporateNames(corporateName)
  end
  def load_corporateNames(corporateName)
    foo = corporateName.to_s
	loadObjects corporateName,MadsCorporateName
  end
  def load_familyNames
    load_familyNames(familyName)
  end
  def load_familyNames(familyName)
    foo = familyName.to_s
	loadObjects familyName,MadsFamilyName
  end
  def load_personalNames
    load_personalNames(personalName)
  end
  def load_personalNames(personalName)
    foo = personalName.to_s
	loadObjects personalName,MadsPersonalName
  end

  ## Event #####################################################################
  def load_events
    load_events(event)
  end
  def load_events(event)
    events = []
    event.each do |e|
      begin
	      if !e.outcome.first.nil? && e.outcome.first != ""
	        # use inline data if available
	        events << e
	      elsif e.pid != nil
	        events << DamsEvent.find(e.pid)
	      end
 	  rescue Exception => e
          puts e.to_s
          puts e.backtrace
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
    object.each do |o|
      name_uri = o.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if (name_pid != nil && name_pid != "" && !(name_pid.include? 'Internal'))
      	objects << className.find(name_pid)
      elsif o.name.first.nil? && o.pid != nil    
        objects << className.find(o.pid)      
      else 
      	objects << o
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

  def insertComplexSubjectFields (solr_doc, cid, objects)
    prefix = (cid != nil) ? "component_#{cid}_" : ""
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    if objects != nil
      objects.each do |obj|
          Solrizer.insert_field(solr_doc, "#{prefix}complexSubject", obj.name)
          Solrizer.insert_field(solr_doc, 'subject', obj.name)
          Solrizer.insert_field(solr_doc, "#{prefix}subject_topic", obj.name, facetable)
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
	  if no.value.first.nil? && no.pid != nil && !no.pid.start_with?("_:")
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
    creation_date = nil
    other_date = nil

    dates.map do |date|
      # display
      if cid != nil
        date_json = {:beginDate=>date.beginDate.first.to_s, :endDate=>date.endDate.first.to_s, :value=>date.value.first.to_s, :type=>date.type.first.to_s, :encoding=>date.encoding.first.to_s }
        Solrizer.insert_field(solr_doc, "component_#{cid}_date_json", date_json.to_json)
      else
        date_json = {
          :beginDate=>date.beginDate.first.to_s,
          :endDate=>date.endDate.first.to_s,
          :value=>date.value.first.to_s,
          :type=>date.type.first.to_s,
          :encoding=>date.encoding.first.to_s
        }
        Solrizer.insert_field(solr_doc, "date_json", date_json.to_json)
      end

      # retrieval
      Solrizer.insert_field(solr_doc, "date", date.value.first)
      Solrizer.insert_field(solr_doc, "date", date.beginDate.first)
      Solrizer.insert_field(solr_doc, "date", date.endDate.first)
      Solrizer.insert_field(solr_doc, "date", date.type.first)
      Solrizer.insert_field(solr_doc, "date", date.encoding.first)
      Solrizer.insert_field(solr_doc, "fulltext", date.value)
      Solrizer.insert_field(solr_doc, "fulltext", date.beginDate)
      Solrizer.insert_field(solr_doc, "fulltext", date.endDate)
      Solrizer.insert_field(solr_doc, "fulltext", date.type)
      Solrizer.insert_field(solr_doc, "fulltext", date.encoding)

      # save dates for sort date
      begin
        dateVal = date.beginDate.first
        if dateVal.match( '^\d{4}$' ) != nil
          dateVal += "-01-01"
        end
        if date.type.first == 'creation'
          creation_date = DateTime.parse(dateVal)
        elsif other_date.nil?
          other_date = DateTime.parse(dateVal)
        end
      rescue
        puts "error parsing date: #{dateVal}"
      end
    end

    datesort = Solrizer::Descriptor.new(:date, :indexed, :stored)
    if creation_date
      Solrizer.insert_field(solr_doc, "object_create", creation_date, datesort)
    elsif other_date
      Solrizer.insert_field(solr_doc, "object_create", other_date, datesort)
    end
  end
  def insertRelationshipFields ( solr_doc, prefix, relationships )

    # build map: role => [name1,name2]
    rels = {}
    relationships.map do |relationship|
      obj = relationship.name.first.to_s      

      rel = nil
	  if !relationship.corporateName.first.nil?
	    rel = relationship.corporateName
	  elsif !relationship.personalName.first.nil?
	    rel = relationship.personalName
	  elsif !relationship.conferenceName.first.nil?
	    rel = relationship.conferenceName
	  elsif !relationship.familyName.first.nil?
	    rel = relationship.familyName 	     	        
      elsif !relationship.name.first.nil?
	    rel = relationship.name    
	  end

      if rel != nil && (rel.first.nil? || rel.first.name.first.nil?)
        rel = relationship.load  
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
        
        begin        
          relRole = relationship.role.first.name.first.to_s
          
          # display     
        
          if !relRole.nil? && relRole != ''
            roleValue = relRole
          else 
            role = relationship.loadRole
            if role != nil
              roleValue = role.name.first.to_s
            end
          end
          if rels[roleValue] == nil
            rels[roleValue] = [name]
          else
            rels[roleValue] << name
          end
        rescue Exception => e
          puts "trapping role error in relationship"
          puts e.backtrace
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
    sort_title = ""
    titles.each do |t|
      name = t.name || ""
      external = t.externalAuthority || ""

      # walk through chain of title elements
      value = t.value || ""
      nonSort = t.nonSort || ""
      partName = t.partName || ""
      partNumber = t.partNumber || ""
      subtitle = t.subtitle || ""
	  variant = t.variant || ""
	  translationVariant = t.translationVariant || ""
	  abbreviationVariant = t.abbreviationVariant || ""
	  acronymVariant = t.acronymVariant || ""
	  expansionVariant = t.expansionVariant || ""
	  
      # structured
      title_json = { :name => name, :external => external, :value => value,
                     :nonSort => nonSort, :partName => partName,
                     :partNumber => partNumber, :subtitle => subtitle, 
                     :variant => variant, :translationVariant => translationVariant,
                     :abbreviationVariant => abbreviationVariant, :acronymVariant => acronymVariant,
                     :expansionVariant => expansionVariant }
      if cid != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_title_json", title_json.to_json)
      else
        Solrizer.insert_field(solr_doc, "title_json", title_json.to_json)
      end

      # retrieval
      Solrizer.insert_field(solr_doc, "title", name)
      Solrizer.insert_field(solr_doc, "titleVariant", variant) if variant.length > 0
      Solrizer.insert_field(solr_doc, "titleTranslationVariant", translationVariant) if translationVariant.length > 0
      Solrizer.insert_field(solr_doc, "titleAbbreviationVariant", abbreviationVariant) if abbreviationVariant.length > 0
      Solrizer.insert_field(solr_doc, "titleAcronymVariant", acronymVariant) if acronymVariant.length > 0
      Solrizer.insert_field(solr_doc, "titleExpansionVariant", expansionVariant) if expansionVariant.length > 0
      Solrizer.insert_field(solr_doc, "fulltext", name)

      # build sort title
      if sort_title == "" && cid == nil
        sort_title = name.first
      end
    end

    # add sort title (out of loop to make sure only once)
    if cid == nil && !sort_title.blank?
      Solrizer.insert_field(solr_doc, "title", sort_title.downcase, Solrizer::Descriptor.new(:string, :indexed, :stored))
    end
  end
  def insertLanguageFields ( solr_doc, field, languages )
    langs = load_languages languages
    if langs != nil
      n = 0
      langs.map.each do |lang|
        n += 1

        Solrizer.insert_field(solr_doc, field, lang.name)
        Solrizer.insert_field(solr_doc, "fulltext", lang.name)
      end
    end
  end

  # def insertProvenanceCollectionPartFields ( solr_doc, field, provenanceCollectionParts )
  #   parts = load_provenanceCollectionParts provenanceCollectionParts
  #   if parts != nil
  #     n = 0
  #     parts.map.each do |part|
  #       n += 1

  #       Solrizer.insert_field(solr_doc, 'part_name', part.title.first.value)
  #       Solrizer.insert_field(solr_doc, 'part_id', part.pid)
  #     end
  #   end
  # end


  def insertRelatedResourceFields ( solr_doc, prefix, relatedResource )

    # relatedResource
    n = 0
    relatedResource.map do |resource|
      n += 1
      related_json = {:type=>resource.type.first.to_s, :uri=>resource.uri.first.to_s, :description=>resource.description.first.to_s}
      Solrizer.insert_field(solr_doc, "related_resource_json", related_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", resource.uri.first.to_s)
      Solrizer.insert_field(solr_doc, "fulltext", resource.type.first.to_s)
      Solrizer.insert_field(solr_doc, "fulltext", resource.description.first.to_s)
      if resource.type.first.to_s == "preview"
        Solrizer.insert_field(solr_doc, "preview", resource.uri.first.to_s)
      end
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
          begin
		    relRole = relationship.role.first.name.first.to_s
	        # display     
	        
	        if !relRole.nil? && relRole != ''
	        	roleValue = relRole
			else 
			  role = relationship.loadRole
			  if role != nil
			  	roleValue = role.name.first.to_s
			  end
			end	      
	        if (roleValue != nil)
               rel_json[:role] = roleValue
            else
			  if !relationship.role.first.nil? && !relationship.role.first.pid.nil? && (relationship.role.first.pid.include? 'dams:')
				rel_json[:role] = relationship.role.first.pid		
			  end	           
	        end  
          rescue
            puts "trapping role error in event for name: #{name}"
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
    super(solr_doc)

    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)

    # title
    insertTitleFields solr_doc, nil, title

    # date
    insertDateFields solr_doc, nil, date

    # relationship
    insertRelationshipFields solr_doc, "", relationship

    # language
    insertLanguageFields solr_doc, "language", language
    
    # provenanceCollectionPart
    #insertProvenanceCollectionPartFields solr_doc, "provenanceCollectionPart", provenanceCollectionPart

    # note
    insertNoteFields solr_doc, 'note', note
    insertNoteFields solr_doc, 'custodialResponsibilityNote', custodialResponsibilityNote
    insertNoteFields solr_doc, 'preferredCitationNote', preferredCitationNote
    insertNoteFields solr_doc, 'scopeContentNote', scopeContentNote

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
    insertComplexSubjectFields solr_doc, nil, load_complexSubjects(complexSubject)

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
    ['system_create_dtsi','system_modified_dtsi','object_create_dtsi'].each {|f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }

    # hack to make sure something is indexed for rights metadata
    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
      solr_doc[f] = 'dams-curator' unless solr_doc[f]
    }
    return solr_doc
  end
end
