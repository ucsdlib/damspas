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
						@tmpArray << c.id				
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
	  	elsif !object.name[0].nil?
	  		type = "MadsName" 	  	
	  	elsif !object.conferenceName[0].nil?
	  		type = "MadsConferenceName" 	  	
	  	elsif !object.corporateName[0].nil?
	  		type = "MadsCorporateName" 	  	  	
	  	elsif !object.personalName[0].nil?
	  		type = "MadsPersonalName" 
	  	elsif !object.familyName[0].nil?
	  		type = "MadsFamilyName" 	
	  	end
		type   
    end
    
    def get_simple_subject_id(object)
    	id = ""
    	if !object.temporal[0].nil?   
	  		id = @dams_object.temporal.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.topic[0].nil?
	  		id = @dams_object.topic.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.builtWorkPlace[0].nil?
	  		id = @dams_object.builtWorkPlace.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.culturalContext[0].nil?
	  		id = @dams_object.culturalContext.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.function[0].nil?
	  		id = @dams_object.function.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.genreForm[0].nil?
	  		id = @dams_object.genreForm.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.geographic[0].nil?
	  		id = @dams_object.geographic.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.iconography[0].nil?
	  		id = @dams_object.iconography.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.occupation[0].nil?
	  		id = @dams_object.occupation.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.scientificName[0].nil?
	  		id = @dams_object.scientificName.to_s.gsub(/.*\//,'')[0..9]
	  	elsif !object.stylePeriod[0].nil?
	  		id = @dams_object.stylePeriod.to_s.gsub(/.*\//,'')[0..9] 	  	
	  	elsif !object.technique[0].nil?
	  		id = @dams_object.technique.to_s.gsub(/.*\//,'')[0..9] 	  	 		  		
	  	elsif !object.name[0].nil?
	  		id = @dams_object.name.to_s.gsub(/.*\//,'')[0..9]	  	
	  	elsif !object.conferenceName[0].nil?
	  		id = @dams_object.conferenceName.to_s.gsub(/.*\//,'')[0..9]	  	
	  	elsif !object.corporateName[0].nil?
	  		id = @dams_object.corporateName.to_s.gsub(/.*\//,'')[0..9] 	  	  	
	  	elsif !object.personalName[0].nil?
	  		id = @dams_object.personalName.to_s.gsub(/.*\//,'')[0..9] 
	  	elsif !object.familyName[0].nil?
	  		id = @dams_object.familyName.to_s.gsub(/.*\//,'')[0..9] 	
	  	end
		id   
    end              
  end
end
