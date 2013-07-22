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
     
  end
end
