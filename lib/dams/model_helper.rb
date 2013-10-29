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

    # make sure an rdf:type triple exists in the graph
    def check_type( graph, subject, type )
      type_stmt = RDF::Statement.new( subject, RDF.type, type )
      graph.insert(type_stmt) unless graph.has_statement?( type_stmt )
    end

    # make sure a mads:authoritativeLabel triple exists in the graph
    def check_label( graph, subject, label )
      val = graph.first_object( [subject, MADS.authoritativeLabel, nil] )
      if (val.blank? || val.value.blank?) && !label.blank?
        graph.insert( [ rdf_subject, MADS.authoritativeLabel, label ] )
      end
    end
  end
end
