module ObjectHelper
  # select files to display
  def select_file( params )
    document  = params[:document]
    component = params[:component]
    max_size  = params[:quality]
    type      = params[:type]
  
    prefix = (component != nil) ? "component_#{component}_" : ""
    files = document["#{prefix}files_tesim"]

    # identify acceptable files
    service_file = nil
    service_file = nil
    display_file = nil
    display_dim  = 0
    files.each{ |fid|
      use = document["#{prefix}file_#{fid}_use_tesim"].first
      qual = document["#{prefix}file_#{fid}_quality_tesim"]
      if qual != nil
        qualArr = qual.first.split("x")
        file_dim = qualArr.max { |a,b| a.to_i <=> b.to_i }.to_i
      end
      if type == nil || use.start_with?(type)
        if use.end_with?("-service")
          service_file = fid
          service_dim = file_dim.to_i
        elsif max_size == nil || file_dim == nil || file_dim < max_size
          if (display_file == nil || file_dim.to_i > display_dim) && (not use.end_with?("-source") )
            display_file = fid
            display_dim  = file_dim.to_i
          end
        end
      end
    }
  
    # build file metadata hash
    info = Hash.new
    if ( service_file != nil )
      info[:service] = select_file_info(
        :document => document, :prefix => prefix,
        :component => component, :file => service_file )
    end
    if ( display_file != nil )
      info[:display] = select_file_info(
        :document => document, :prefix => prefix,
        :component => component, :file => display_file )
    end
    info
  end

  # extract info for a single file from solr
  def select_file_info( params )
    document = params[:document]
    component = params[:component]
    file = params[:file]
    prefix = params[:prefix]
  
    file_info = Hash.new
    if component != nil
      file_info['component'] = component
    end
    file_info['file'] = file
    document.each { |key,val|
      file_prefix = "#{prefix}file_#{file}"
      if key.start_with?(file_prefix)
        file_info[ key[file_prefix.length+1..-1] ] = val
      end
    }
    file_info
  end

end
