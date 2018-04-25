module Dams
  module ControllerHelper
    
    #Mapping for OSF API
		def osf_title(document)
			  field_name = "title_json_tesim"
		    dams_data= document["#{field_name}"]
		    osf_data=''

		  if dams_data != nil
		    dams_data.each do |datum|
		      title = JSON.parse(datum)
		      osf_data = title['name'] ? title['name'] : ''
		      osf_data += title['name'] && !title['translationVariant'].blank? ? ' : ' : ''
		      title_trans = title['translationVariant'] || []
		      if title_trans.class == Array
		      	title_trans.each do |trans|  
		      		osf_data +=	trans
		      	end
		      elsif title_trans.class == String
		      	osf_data +=	title_trans
		      end
		    end
		  end
		  osf_data
		end

		def osf_contributors(document)
			field_name = "relationship_json_tesim"
			dams_data = document["#{field_name}"]
			osf_data =[]

			if dams_data != nil
		    dams_data.each do |datum|
		    	
		      relationships = JSON.parse(datum)
		    	relationships.each do |key, value|
		    		value.each do |v|
		   				osf_data << {"name": v}
		   			end
		   		end
		    end
		  end
		  osf_data = (osf_data.blank?) ? osf_data << {"name": "UC San Diego Library"} : osf_data
		end

		def osf_description(document)
			field_name = "otherNote_json_tesim"
			dams_data = document["#{field_name}"]
			osf_data = ''

			if dams_data != nil
		    dams_data.each do |datum|
		      other_note = JSON.parse(datum)
		      osf_data = other_note['value'] if other_note['type'] == 'description'
		    end
		  end
		  osf_data
		end 

		def osf_uris(document)
			field_name = "id"
			dams_data = document["#{field_name}"]
			osf_data = {}

			if dams_data != nil
				url = "http://library.ucsd.edu/dc/collection/#{dams_data}"
		    osf_data = {"canonicalUri": url, "providerUris": url}
		  end
		  osf_data
		end

		def osf_date(document)
			field_name = "date_json_tesim"
			dams_data = document["#{field_name}"]
			osf_data = ''
			
			if dams_data != nil
		    dams_data.each do |datum|
		      date = JSON.parse(datum)
		      if date['type'] == 'issued'
						d_date = date['beginDate']|| ''
						osf_data = DateTime.new(d_date.to_i,1,1) if d_date.match( '^\d{4}$' )
					end
		    end
		  end
		  osf_data = (osf_data.is_a?(Time) || osf_data.is_a?(DateTime)) ? osf_data : Time.now
		end

		def osf_languages(document)
			field_name = "language_tesim"
			dams_data = document["#{field_name}"]
      langs = dams_data || []
      osf_data = []

      if langs.class == Array
      	langs.each do |lang|  
      		osf_data <<	lang
      	end
      elsif langs.class == String
      	osf_data <<	langs
      end
			osf_data 
		end

		def osf_mads_fields(document)
			osf_data = []

			field_names = [
				'geographic_tesim', 
				'topic_tesim',
				'commonName_tesim', 
				'scientificName_tesim', 
				'corporateName_tesim',
				'personalName_tesim',
				'subject_tesim',
				'genreForm_tesim',
				'anatomy_tesim',
				'cruise_tesim',
				'series_tesim',
				'culturalContext_tesim',
				'lithology_tesim'
			]
		  field_names.each do |field_name|
		    dams_data = document["#{field_name}"]
			  if dams_data.kind_of?(String)
			  	osf_data << dams_data 
		    elsif dams_data.kind_of?(Array)
		    	dams_data.each do |datum| 
		    		osf_data << datum
		    	end
		    end 
		  end
		  osf_data
		end

		def osf_publisher
			osf_data = {"name": "UC San Diego Library, Digital Collections", "uri": "http://library.ucsd.edu/dc"}
		end

		def export_to_API(document)
		  field_map = {
		    'title': osf_title(document),
		    'description': osf_description(document),
		    'contributor': osf_contributors(document),
		    'uris': osf_uris(document),
		    'languages': osf_languages(document),
		    'providerUpdatedDateTime': osf_date(document),
		    'tags': osf_mads_fields(document),
		    'publisher': osf_publisher
		  }
		  json_data = {"jsonData": field_map}
		end

# Retrieve label from solr index instead of external record from repo
 def get_linked_object_label(id)
	  	@doc = get_search_results(:q => "id:#{id}")
	  	field = "name_tesim";
		
        @doc.each do |col| 
			if col.class == Array
				col.each do |c|
					if(c.key?("#{field}"))
						@label= c.fetch("#{field}").first
				  end
				end
			end
		end
       @label
  end

 # Returns an array of JSON objects with id and label
    def get_objects_json(object_type_param,field)
	  	@doc = get_search_results(:q => "has_model_ssim:info:fedora/afmodel:#{object_type_param}", :rows => '10000')
	  	@objects = Array.new
	  	@doc.each do |col| 
			if col.class == Array
				col.each do |c|
					if(c.key?("#{field}"))
						@tmpObject = {:id =>Rails.configuration.id_namespace+c.id,:label=>c.fetch("#{field}").first}
								
						@objects << @tmpObject
					end
				end
			end
		end
		
		@objectsJson = @objects.to_json
    end


    def get_objects(object_type_param,field)
	  	@doc = get_search_results(:q => "has_model_ssim:info:fedora/afmodel:#{object_type_param}", :rows => '10000')
	  	@objects = Array.new
	  	@doc.each do |col| 
			if col.class == Array
				col.each do |c|
					if(c.key?("#{field}"))
						@tmpArray = Array.new
						@tmpArray << c.fetch("#{field}").first
						if(object_type_param.include? 'MadsScheme')
							@tmpArray << Rails.configuration.id_namespace+c.id
						else
							@tmpArray << c.id
						end			
						@objects << @tmpArray
					end
				end
			end
		end
		@objects.sort {|a,b|a[0].downcase <=> b[0].downcase}     
    end

    def get_objects_url(object_type_param,field)
	  	@doc = get_search_results(:q => "has_model_ssim:info:fedora/afmodel:#{object_type_param}", :rows => '10000')
	  	@objects = Array.new
	  	@doc.each do |col| 
			if col.class == Array
				col.each do |c|
					if(c.key?("#{field}"))
						@tmpArray = Array.new
						@tmpArray << c.fetch("#{field}").first
						@tmpArray << Rails.configuration.id_namespace+c.id
								
						@objects << @tmpArray
					end
				end
			end
		end
		
		@objects.sort {|a,b|a[0].downcase <=> b[0].downcase}     
    end

    def get_related_resource_url(object_type_param,field1,field2)
	  	@doc = get_search_results(:q => "has_model_ssim:info:fedora/afmodel:#{object_type_param}", :rows => '10000')
	  	@objects = Array.new
	  	@doc.each do |col| 
			if col.class == Array
				col.each do |c|	
					type = nil
					desc = nil
					if(c.key?("#{field1}"))
						type = c.fetch("#{field1}").first										
					end
					if(c.key?("#{field2}"))
						desc = c.fetch("#{field2}").first											
					end	
					
					@tmpArray = Array.new
					resourceLabel = nil
					if(!type.nil? && !desc.nil? && desc.length > 0 && type.length > 0)
						resourceLabel = type + " - " + desc
					elsif(desc.nil? && !type.nil? && type.length > 0)
						resourceLabel = type
					elsif(type.nil? && !desc.nil? && desc.length > 0)
						resourceLabel = desc
					end
					
					if(!resourceLabel.nil?)
						@tmpArray << resourceLabel
						@tmpArray << Rails.configuration.id_namespace+c.id		
						@objects << @tmpArray
					end		
				end
			end
		end
		
		@objects.sort {|a,b|a[0].downcase <=> b[0].downcase}     
    end

    def get_related_resources(document)
      relResourceData = document["related_resource_json_tesim"]
	  @relResourceHash = Hash.new
	  if !relResourceData.nil? and relResourceData.length > 0
	    relResourceData.each do |datum|
          relResource = JSON.parse(datum)
          if(!relResource['uri'].nil? and relResource['uri'].length > 0 and relResource['uri'].start_with?( Rails.configuration.id_namespace ))         
	  		@relResourceHash.store(relResource['uri'],relResource['description'])
	  	  end
	  	end
	  end
	  return @relResourceHash
    end
               
    def get_relationship_name_id(object)
    	if(!object.relationshipNameURI.nil? && !object.relationshipNameURI.nil? && object.relationshipNameURI.class != Array)
		  	if(!object.relationshipNameURI.personalName.nil? && !object.relationshipNameURI.personalName.empty?)
		  		object.relationshipNameURI.personalName.to_s.gsub(/.*\//,'')[0..9]
		  	elsif(!object.relationshipNameURI.name.empty?)
		  		object.relationshipNameURI.name.to_s.gsub(/.*\//,'')[0..9]
		  	elsif(!object.relationshipNameURI.corporateName.empty?)
		  		object.relationshipNameURI.corporateName.to_s.gsub(/.*\//,'')[0..9] 
		  	elsif(!object.relationshipNameURI.conferenceName.empty?)
		  		object.relationshipNameURI.conferenceName.to_s.gsub(/.*\//,'')[0..9]
		  	elsif(!object.relationshipNameURI.familyName.empty?)
		  		object.relationshipNameURI.familyName.to_s.gsub(/.*\//,'')[0..9]    		  		  		 	  		
		  	end 
		end       
    end

    def get_relationship_name_type(object)
    	type = ""
    	if(!object.relationshipNameURI.nil? && !object.relationshipNameURI.nil? && object.relationshipNameURI.class != Array)
		  	if(!object.relationshipNameURI.personalName.nil? && !object.relationshipNameURI.personalName.empty?)
		  		type = "PersonalName"
		  	elsif(!object.relationshipNameURI.name.empty?)
		  		type = "Name"		  	
		  	elsif(!object.relationshipNameURI.corporateName.empty?)
		  		type = "CorporateName"
		  	elsif(!object.relationshipNameURI.conferenceName.empty?)
		  		type = "ConferenceName"
		  	elsif(!object.relationshipNameURI.familyName.empty?)
		  		type = "FamilyName"   		  		  		 	  		
		  	end 
		end    
		type   
    end
                              
    def get_simple_subject_type(object)
    	type = ""
   		if !object.temporal[0].nil?
	  		type = "MadsTemporal" 
	  	elsif !object.topic[0].nil?
	  		type = "MadsTopic" 
	  	elsif !object.builtWorkPlace[0].nil?
	  		type = "DamsBuiltWorkPlace" 
	  	elsif !object.culturalContext[0].nil?
	  		type = "DamsCulturalContext" 
	  	elsif !object.function[0].nil?
	  		type = "DamsFunction" 
	  	elsif !object.genreForm[0].nil?
	  		type = "MadsGenreForm" 
	  	elsif !object.geographic[0].nil?
	  		type = "MadsGeographic"
	  	elsif !object.iconography[0].nil?
	  		type = "DamsIconography" 	  	
	  	elsif !object.occupation[0].nil?
	  		type = "MadsOccupation" 	  	
	  	elsif !object.scientificName[0].nil?
	  		type = "DamsScientificName" 
	  	elsif !object.stylePeriod[0].nil?
	  		type = "MadsStylePeriod" 	  	
	  	elsif !object.technique[0].nil?
	  		type = "DamsTechnique"
	  	elsif !object.lithology[0].nil?
	  		type = "DamsLithology"
	  	elsif !object.series[0].nil?
	  		type = "DamsSeries"
	  	elsif !object.cruise[0].nil?
	  		type = "DamsCruise"	 
	  	elsif !object.anatomy[0].nil?
	  		type = "DamsAnatomy"	 			  			  		
	  	end 	  	 		  		
		type   
    end
    
    def get_simple_subject_id(object)
    	id = ""
    	if !object.temporal[0].nil?   
	  		id = object.temporal.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.topic[0].nil?
	  		id = object.topic.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.builtWorkPlace[0].nil?
	  		id = object.builtWorkPlace.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.culturalContext[0].nil?
	  		id = object.culturalContext.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.function[0].nil?
	  		id = object.function.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.genreForm[0].nil?
	  		id = object.genreForm.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.geographic[0].nil?
	  		id = object.geographic.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.iconography[0].nil?
	  		id = object.iconography.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.occupation[0].nil?
	  		id = object.occupation.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.scientificName[0].nil?
	  		id = object.scientificName.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.stylePeriod[0].nil?
	  		id = object.stylePeriod.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.technique[0].nil?
	  		id = object.technique.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.lithology[0].nil?
	  		id = object.lithology.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.series[0].nil?
	  		id = object.series.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.cruise[0].nil?
	  		id = object.cruise.to_s.gsub(/.*\//,'')[0..9]	
	  	elsif !object.anatomy[0].nil?
	  		id = object.anatomy.to_s.gsub(/.*\//,'')[0..9]  			  			  		
	  	end
		id   
    end
    
    def get_simple_subject_value(object)
    	value = ""
    	if !object.temporal[0].nil?   
	  		value = object.temporal.first.name.first
	  	elsif !object.topic[0].nil?
	  		value = object.topic.first.name.first
	  	elsif !object.builtWorkPlace[0].nil?
	  		value = object.builtWorkPlace.first.name.first
	  	elsif !object.culturalContext[0].nil?
	  		value = object.culturalContext.first.name.first
	  	elsif !object.function[0].nil?
	  		value = object.function.first.name.first 
	  	elsif !object.genreForm[0].nil?
	  		value = object.genreForm.first.name.first
	  	elsif !object.geographic[0].nil?
	  		value = object.geographic.first.name.first
	  	elsif !object.iconography[0].nil?
	  		value = object.iconography.first.name.first 	  	
	  	elsif !object.occupation[0].nil?
	  		value = object.occupation.first.name.first 	  	
	  	elsif !object.scientificName[0].nil?
	  		value = object.scientificName.first.name.first
	  	elsif !object.stylePeriod[0].nil?
	  		value = object.stylePeriod.first.name.first 	  	
	  	elsif !object.technique[0].nil?
	  		value = object.technique.first.name.first 	  	 		  		
	  	elsif !object.lithology[0].nil?
	  		value = object.lithology.first.name.first
	  	elsif !object.series[0].nil?
	  		value = object.series.first.name.first 	  	
	  	elsif !object.cruise[0].nil?
	  		value = object.cruise.first.name.first
	  	elsif !object.anatomy[0].nil?
	  		value = object.anatomy.first.name.first
	  	end
		value   
    end  
    
    def get_simple_subjects(object)   	
    	simpleSubjectArray = Array.new

     

	  	object.temporal.each do |temp|

  		  simpleSubjectArray << {
		    :name => "Temporal", :value => get_pid(temp), :label => get_linked_object_label(get_pid(temp))
		  }	  		
	  	end
	  	
	  	object.topic.each do |top|
        simpleSubjectArray << {
		    :name => "Topic", :value => get_pid(top), :label => get_linked_object_label(get_pid(top))
		  }	  		
	  	end
	  	
	  	object.builtWorkPlace.each do |built|
  		  simpleSubjectArray << {
		    :name => "BuiltWorkPlace", :value => get_pid(built),:label => get_linked_object_label(get_pid(built))
		  }
	  	end

	  	object.culturalContext.each do |cultural|
  		  simpleSubjectArray << {
		    :name => "CulturalContext", :value => get_pid(cultural), :label => get_linked_object_label(get_pid(cultural))
		  }	  		
	  	end

	  	object.function.each do |fun|
  		  simpleSubjectArray << {
		    :name => "Function", :value => get_pid(fun), :label => get_linked_object_label(get_pid(fun))
		  }	  		
	  	end
	  	
	  	object.genreForm.each do |genre|
  		  simpleSubjectArray << {
		    :name => "GenreForm", :value => get_pid(genre), :label => get_linked_object_label(get_pid(genre))
		  }	  		
	  	end
	  	
	  	object.geographic.each do |geo|
  		  simpleSubjectArray << {
		    :name => "Geographic", :value => get_pid(geo), :label => get_linked_object_label(get_pid(geo))
		  }	  		
	  	end
	  	
	  	object.iconography.each do |icon|
  		  simpleSubjectArray << {
		    :name => "Iconography", :value => get_pid(icon), :label => get_linked_object_label(get_pid(icon))
		  }	  		
	  	end
	  	
	  	object.occupation.each do |occ|
  		  simpleSubjectArray << {
		    :name => "Occupation", :value => get_pid(occ), :label => get_linked_object_label(get_pid(occ))
		  }	  		
	  	end
	  	
	  	object.scientificName.each do |sci|
  		  simpleSubjectArray << {
		    :name => "ScientificName", :value => get_pid(sci), :label => get_linked_object_label(get_pid(sci))
		  }	  		
	  	end
	  	
	  	object.stylePeriod.each do |style|
  		  simpleSubjectArray << {
		    :name => "StylePeriod", :value => get_pid(style), :label => get_linked_object_label(get_pid(style))
		  }	  		
	  	end
	  	
	  	object.technique.each do |tech|
  		  simpleSubjectArray << {
		    :name => "Technique", :value => get_pid(tech), :label => get_linked_object_label(get_pid(tech))
		  }		  		
	  	end

	  	object.lithology.each do |li|
  		  simpleSubjectArray << {
		    :name => "Lithology", :value => get_pid(li), :label => get_linked_object_label(get_pid(li))
		  }	  		
	  	end
	  	
	  	object.series.each do |ser|
  		  simpleSubjectArray << {
		    :name => "Series", :value => get_pid(ser), :label => get_linked_object_label(get_pid(ser))
		  }	  		
	  	end
	  	
	  	object.cruise.each do |cru|
  		  simpleSubjectArray << {
		    :name => "Cruise", :value => get_pid(cru), :label => get_linked_object_label(get_pid(cru))
		  }		  		
	  	end

	  	object.anatomy.each do |an|
  		  simpleSubjectArray << {
		    :name => "Anatomy", :value => get_pid(an), :label => get_linked_object_label(get_pid(an))
		  }	  		
	  	end
	  		
		simpleSubjectArray   
    end
	def get_pid(object)
      if object.class == RDF::URI
        object.to_s.gsub(/.*\//,'')
      else
        object.pid
      end
    end
           
    def get_name_type(object)
    	type = ""
   		if !object.name[0].nil?
	  		type = "Name" 	  	
	  	elsif !object.conferenceName[0].nil?
	  		type = "ConferenceName" 	  	
	  	elsif !object.corporateName[0].nil?
	  		type = "CorporateName" 	  	  	
	  	elsif !object.personalName[0].nil?
	  		type = "PersonalName" 
	  	elsif !object.familyName[0].nil?
	  		type = "FamilyName" 	
	  	end
		type   
    end
    
   def get_name_id(object)
    	id = ""
		if !object.name[0].nil?
	  		id = object.name.to_s.gsub(/.*\//,'')[0..9]	  	
	  	elsif !object.conferenceName[0].nil?
	  		id = object.conferenceName.to_s.gsub(/.*\//,'')[0..9]	  	
	  	elsif !object.corporateName[0].nil?
	  		id = object.corporateName.to_s.gsub(/.*\//,'')[0..9] 	  	  	
	  	elsif !object.personalName[0].nil?
	  		id = object.personalName.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.familyName[0].nil?
	  		id = object.familyName.to_s.gsub(/.*\//,'')[0..9] 	
	  	end
		id   
    end
    
    def get_name_value(object)
    	value = ""
    	if !object.name[0].nil?
	  		value = object.name.first.name.first	  	
	  	elsif !object.conferenceName[0].nil?
	  		value = object.conferenceName.first.name.first	  	
	  	elsif !object.corporateName[0].nil?
	  		value = object.corporateName.first.name.first 	  	  	
	  	elsif !object.personalName[0].nil?
	  		value = object.personalName.first.name.first 
	  	elsif !object.familyName[0].nil?
	  		value = object.familyName.first.name.first 	
	  	end
		value   
    end
    def get_creators(object)   	
    	creatorArray = Array.new

	  	object.conferenceName.each do |conf|
  		  creatorArray << {
		    :name => "ConferenceName",
		    :value => conf.pid,
        :label => get_linked_object_label(get_pid(conf))			  
		  }	  		
	  	end
	  	
	  	object.corporateName.each do |corp|
  		  creatorArray << {
		    :name => "CorporateName",
		    :value => corp.pid,	
        :label => get_linked_object_label(get_pid(corp))		  
		  }	  		
	  	end

		object.familyName.each do |fam|
  		  creatorArray << {
		    :name => "FamilyName",
		    :value => fam.pid,
        :label => get_linked_object_label(get_pid(fam))			  
		  }	  		
	  	end

	   	object.name.each do |nam|
  		  creatorArray << {
		    :name => "Name",
		    :value => nam.pid,
        :label => get_linked_object_label(get_pid(nam))			  
		  }	  		
	  	end

	  	object.personalName.each do |pers|
  		  creatorArray << {
		    :name => "PersonalName",
		    :value => pers.pid,		
        :label => get_linked_object_label(get_pid(pers))	  
		  }
	  	end

		creatorArray
					  
    end

   def get_rights_holders(object)   	
    	rightsHolderArray = Array.new

	  	object.rightsHolderConference.each do |conf|
  		  rightsHolderArray << {
		    :name => "RightsHolderConference",
		    :value => conf.pid,			  
		  }	  		
	  	end
	  	
	  	object.rightsHolderCorporate.each do |corp|
  		  rightsHolderArray << {
		    :name => "RightsHolderCorporate",
		    :value => corp.pid,			  
		  }	  		
	  	end

		object.rightsHolderFamily.each do |fam|
  		  rightsHolderArray << {
		    :name => "RightsHolderFamily",
		    :value => fam.pid,			  
		  }	  		
	  	end

	   	object.rightsHolderName.each do |nam|
  		  rightsHolderArray << {
		    :name => "RightsHolderName",
		    :value => nam.pid,			  
		  }	  		
	  	end

	  	object.rightsHolderPersonal.each do |pers|
  		  rightsHolderArray << {
		    :name => "RightsHolderPersonal",
		    :value => pers.pid,			  
		  }
	  	end

		rightsHolderArray
					  
    end
    
    def get_relationships(object)   	
    	relationshipArray = Array.new
		relationship = object.relationship
		roleId = ""
		if(!relationship.nil?)
			relationship.each do |relation|
				if(!relation.role.nil?)
					roleId = relation.role.first.pid
				end

			  	relation.conferenceName.each do |conf|
		  		  relationshipArray << {
				    :name => "ConferenceName",
				    :nameId => conf.pid,	
				    :roleId => "#{roleId}",		  
				  }	  		
			  	end
			  	
			  	relation.corporateName.each do |corp|
		  		  relationshipArray << {
				    :name => "CorporateName",
				    :nameId => corp.pid,
				    :roleId => "#{roleId}",				  
				  }	  		
			  	end
		
				relation.familyName.each do |fam|
		  		  relationshipArray << {
				    :name => "FamilyName",
				    :nameId => fam.pid,
				    :roleId => "#{roleId}",				    			  
				  }	  		
			  	end
		
			   	relation.name.each do |nam|
		  		  relationshipArray << {
				    :name => "Name",
				    :nameId => nam.pid,
				    :roleId => "#{roleId}",				    			  
				  }	  		
			  	end
		
			  	relation.personalName.each do |pers|
		  		  relationshipArray << {
				    :name => "PersonalName",
				    :nameId => pers.pid,
				    :roleId => "#{roleId}",				    			  
				  }
			  	end
			  			  	
			end
		end
		relationshipArray   
    end
        
    def index_links(object)
      	solrizer = Solrizer::Fedora::Solrizer.new
  		object.language.each do |lang|
  			if(!lang.pid.nil? && lang.pid.to_s.length > 0)
  				solrizer.solrize lang.pid
  			end
  		end  
    end                                   

    def attach_file(object, file)
      if file.nil? || !file.respond_to?(:original_filename)
        return { alert: "No file uploaded" }
      else
        # set the filename
        @ds = "_1" # XXX TODO list files and choose next file id
        ext = File.extname(file.original_filename)
        @ds += ext unless ext.nil?

        # check mime type and include derivatives hook if derivable
        mt = file.content_type
        if ext.include?("wav") || ext.include?("tif") || ext.include?("mov") || ext.include?("avi") || ext.include?("pdf")
          # add the file and save the object
	      object.add_file( file, @ds, file.original_filename )
	      object.save!
          logger.warn "audit: #{session[:user_id]} create File #{object.id}/#{@ds}"
          Audit.create( user: session[:user_id], action: "create", classname: "File", object: "#{object.id}/#{@ds}")
          return { notice: "File Uploaded", deriv: @ds }
        else
          return { alert: "File Type #{mt} is not supported. Supported File Types: TIFF, WAV, MOV, AVI, PDF"}
        end
      end
    end

 	def get_colletion_objects(collectionObjId, collectionObjArray,classType)
	  if(!collectionObjId.nil?)
        collectionObjId.each do |colId|
		  collectionObj = classType.find( colId.to_s.gsub(/.*\//,'')[0..9] )
		  if (!collectionObj.nil?)
		    collectionObjArray << collectionObj
		  end	
		end
	  end
 	end
 		
    def create_derivatives(object, file, fullPath)
      if file.nil? || !file.respond_to?(:original_filename)
        return { alert: "No file uploaded" }
      else       
	  begin
        # set the filename
        @ds = "_1" # XXX TODO list files and choose next file id
        ext = File.extname(file.original_filename)
        @ds += ext unless ext.nil?
        	    
	    dspart = @ds.split("_")
	    
	    if ( dspart.length == 2 )
	      @cid = nil
	      @fid = dspart[1]
	    elsif ( dspart.length == 3 )
	      @cid = dspart[1]
	      @fid = dspart[2]
	    else
	      return{ notice: "Invalid datastream name: #@ds" }
	      return
	    end
	
	    # add any extension stripped by rails
	    ext = File.extname(fullPath)
	    @fid += ext unless ext.nil?
	
	    # build url to make damsrepo generate derivs
	    user = ActiveFedora.fedora_config.credentials[:user]
	    pass = ActiveFedora.fedora_config.credentials[:password]
	    url = "#{dams_api_path}/api/files/#{object}/"
	    url += "#{@cid}/" unless @cid.nil?
	    url += "#{@fid}/derivatives?format=json"

	    # call damsrepo
	    puts "URL to create derivatives --------------- #{url}"
	    response = RestClient::Request.new(
	        :method => :post, :url => url, :user => user, :password => pass
	      ).execute
	    json = JSON.parse(response.to_str)
	    if json['status'] == 'OK'
	       return { notice: json['message']}
	    else
	       return { alert: json['message'] }
	    end


	    rescue Exception => e
	      logger.warn "Error generating derivatives #{e.to_s}"
	      return { alert: e.to_s}
	    end
      end
    end

    def dams_api_path
      ActiveFedora.fedora_config.credentials[:url].gsub(/\/fedora$/,'')
    end
    def mint_doi( id )
      dams_post "#{dams_api_path}/api/objects/#{id}/mint_doi?format=json"
    end
    def dams_post( url )
      user = ActiveFedora.fedora_config.credentials[:user]
      pass = ActiveFedora.fedora_config.credentials[:password]
      response = RestClient::Request.new(
        :method => :post, :url => url, :user => user, :password => pass
      ).execute
      JSON.parse(response.to_str)
    end

    
    def get_html_data ( params, controller_path )
       xsl = (params[:xsl].nil? || params[:xsl].empty?)?'review.xsl':params[:xsl]
       controller = (controller_path.nil? || controller_path.empty?)?'':'&controller=' + URI.encode(controller_path)
       viewerUrl = "#{dams_api_path}/api/objects/#{params[:id]}/transform?recursive=true&xsl=#{xsl}&baseurl=" + URI.encode(dams_api_path) + controller
       uri = URI(viewerUrl)
       res = Net::HTTP.get_response(uri)
       res.body
    end       

    def get_data ( recursive = true, format )
       format = format.blank? ? 'xml':format
       viewerUrl = "#{dams_api_path}/api/objects/#{params[:id]}?" + (recursive ? "recursive=true&" : "") + "format=#{format}"
       uri = URI(viewerUrl)
       res = Net::HTTP.get_response(uri)
       res.body
    end

    def audit( id = "unknown" )
      classname = self.class.name.gsub("sController","")
      logger.warn "audit: #{session[:user_id]} #{params[:action]} #{classname} #{id}"
      Audit.create( user: session[:user_id], action: params[:action], classname: classname, object: id)
    end

    # parse a request's referrer and figure out which controller it came from
    def referrer_controller( request )
      uri = URI(request.referrer || "")
      if uri.host == request.host
        begin
          ref = Rails.application.routes.recognize_path(uri.path.gsub(/^\/dc/,""))
          ref[:controller]
        rescue Exception => e
          logger.warn "Referer controller error: #{e}"
        end
      end
    end

  def metadata_display?(data)
    result = false
    unless data.nil?
      data.each do |datum|
        result = true if datum.include?('localDisplay') || datum.include?('metadataDisplay')
      end
    end
    result
  end
  end
end
