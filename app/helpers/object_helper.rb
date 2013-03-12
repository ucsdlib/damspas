module ObjectHelper
  #---
  # select_file: Select files to display
  #---
  def select_file( params )
    document  = params[:document]
    component = params[:component]
    max_size  = params[:quality]
    type      = params[:type]
  
    prefix = (component != nil) ? "component_#{component}_" : ""
    files = document["#{prefix}files_tesim"]

    # identify acceptable files
    service_file = nil
    service_use = nil
    service_dim = 0
    display_file = nil
    display_dim  = 0
    if files != nil
      files.each{ |fid|
        use = document["#{prefix}file_#{fid}_use_tesim"]
        if use != nil
          use = use.first
        end
        qual = document["#{prefix}file_#{fid}_quality_tesim"]
        if qual != nil
          qualArr = qual.first.split("x")
          file_dim = qualArr.max { |a,b| a.to_i <=> b.to_i }.to_i
        end
        if type == nil || use.start_with?(type)
          if use != nil && use.end_with?("-service")
            if (service_file == nil || service_use.start_with?("image-") )
              service_file = fid
              service_use = use
              service_dim = file_dim.to_i
            end
          elsif max_size == nil || file_dim == nil || file_dim.to_i < max_size
            if (display_file == nil || file_dim.to_i > display_dim) && use != nil && (not use.end_with?("-source") )
              display_file = fid
              display_dim  = file_dim.to_i
            end
          end
        end
      }
    end
  
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

  #---
  # select_file_info: Extract info for a single file from solr
  #---
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
  
  #---
  # render_file_type
  #---
  def render_file_type( params )
    component = params[:component]

    if component=="0"
      files = select_file( :document=>@document, :quality=>450 )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>450 )
    end
   
    file_info = files[:service]
    if file_info != nil
      use = file_info['use_tesim'].first
    end
  end

  #---
  # render_service_file
  #---
  def render_service_file( params )
    component = params[:component]

    if component=="0"
      files = select_file( :document=>@document,:quality=>450 )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>450 )
    end

    service_file = files[:service]
    if service_file != nil
      services=service_file["file"]
    end
  end

  #---
  # render_display_file
  #---
  def render_display_file( params )
    component = params[:component]

    if component=="0"
      files = select_file( :document=>@document,:quality=>450 )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>450 )
    end

    if files.has_key?(:display)
      display_file = files[:display]
      display=display_file["file"]
    else
      service_file = files[:service]
      if service_file != nil
        services=service_file["file"]
      
        #---
        # todo: replace no_display with appreciate icons"
        #--
        if services.include?('mp3')
          display = "no_display" 
        elsif services.include?('tar.gz')||services.include?('tar')||services.include?('zip')||services.include?('xml')
          display = "no_display"
        end
      end
    end
    display
  end

end
