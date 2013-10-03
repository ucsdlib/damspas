module Dams
  module ControllerHelper
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
		@objects     
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
		@objects     
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
	  	end
		value   
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
  end
end
