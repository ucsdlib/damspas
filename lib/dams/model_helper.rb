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

    # load source capture records (internal or external from repo)
  def load_sourceCapture(sourceCapture)
    srcCap = sourceCapture.first
    if srcCap.class.name == 'DamsSourceCaptureInternal' && (!srcCap.captureSource.first.blank? || !srcCap.sourceType.first.blank? || !srcCap.imageProducer.first.blank?)
      # use internal objects as-is
      srcCap
    elsif !srcCap.nil?
      # fetch external records from the repo
      if !srcCap.pid.blank? && !srcCap.pid.start_with?("_")
        begin
          obj = DamsSourceCapture.find(srcCap.pid)
        rescue Exception => e
          puts "Error loading SourceCapture: #{e}"
        end
        obj
      else
        puts "Empty SourceCapture and invalid pid: '#{srcCap.pid}'"
      end
    end
  end

  end
end
