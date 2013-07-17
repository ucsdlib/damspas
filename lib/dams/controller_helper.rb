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
  end
end
