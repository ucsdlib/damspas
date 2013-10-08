module Dams
  module ModelHelper
    # translate format names from standard from to user display form
    def format_name( format )
      if format.kind_of? Array
        new_formats = []
        format.each do |f|
          new_formats << format_name(f)
        end
        new_formats
      elsif format && Rails.configuration.format_map[format]
        Rails.configuration.format_map[format]
      else
        format
      end 
    end
  end
end
