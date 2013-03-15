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
  # render_file_use
  #---
  def render_file_use( params )
    component = params[:component]
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document, :quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
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
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document, :quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
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
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document,:quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
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

	#------------------------
	# COMPONENT TREE METHODS
	#------------------------

	#---
	# Render a component's title.
	#
	# @param index The object's component index.
	# @return nil
	# @author David T.
	#---
	def componentTitle(index)
		concat render_document_show_field_value(:document=>@document, :field=>"component_#{index}_1_title_tesim")
		return nil
	end

	#---
	# Get the file type value from the component's file use value
	#
	# @param fileUse The component's file use (type/role) value ("component_X_file_X_use_tesim"). E.g., "image-service", "audio-service", etc.
	# @return A string that is the file type value for our component.
	# @author David T.
	#---
	def grabFileType(fileUse)
		fileType = (fileUse) ? fileUse.split("-").first : 'no-files'
	end

	#---
	# Determines which Bootstrap icon glyph to use based on a component's file type.
	#
	# @param fileUse The component's file use (type/role) value ("component_X_file_X_use_tesim"). E.g., "image-service", "audio-service", etc.
	# @return A string that is the CSS class name of the icon we want to display.
	# @author David T.
	#---
	def grabIcon(fileUse)
		icon = grabFileType(fileUse)
		case icon
			when 'image'
				icon = 'icon-picture'
			when 'audio'
				icon = 'icon-music'
			when 'video'
				icon = 'icon-film'
			when 'no-files'
				icon = 'icon-stop'
			else
				icon ='icon-file'
		end
		return icon
	end

	#---
	# Renders a node of the COV component tree.
	#
	# @param index The object's component index.
	# @return nil
	# @author David T.
	#---
	def displayNode(index)

		fileUse = render_file_use(:component=>index,:quality=>450)
		btnID = "tree-button-#{index}"
		btnAttrForFiles = "onClick='showComponent(#{index});'"
		btnAttrForParents = (@isParent[index]) ? "data-toggle='collapse' data-target='#meta-component-#{index}'" : ''
		btnIcon = (@isParent[index]) ? "icon-chevron-right" : grabIcon(fileUse)
		btnCSS = (fileUse) ? "tree-file #{@firstButton}" : ''
		btnCSS += (@isParent[index]) ? " tree-parent" : ''

		concat "<li>".html_safe
		concat "<button type='button' id='#{btnID}' class='btn btn-block btn-small btn-link #{btnCSS}' #{btnAttrForFiles} #{btnAttrForParents}><i class='#{btnIcon}'></i> ".html_safe
		componentTitle index
		concat "</button>".html_safe

		# Display children if parent
		if (@isParent[index])

			concat "<ul id='meta-component-#{index}' class='unstyled collapse'>".html_safe
			@document["component_#{index}_children_isim"].each do |sub|
				displayNode sub
				@seen.push(sub)
			end
			concat "</ul>".html_safe

		end

		concat "</li>".html_safe

		@firstButton = nil

	end

	#---
	# Renders the COV component tree.
	#
	# @param component_count An integer value representing the amount of components an object has ("component_count_isi").
	# @return nil
	# @author David T.
	#---
	def displayComponentTree(component_count)
		if component_count != nil && component_count > 0
			concat '<ul class="unstyled">'.html_safe
			for i in 1..component_count
				if @seen.count(i) == 0
					displayNode i
				end
			end
			concat '</ul>'.html_safe
		end
		return nil
	end

	#---
	# Initializes the arrays used to build the COV component tree.
	#
	# @param component_count An integer value representing the amount of components an object has ("component_count_isi").
	# @return nil
	# @author David T.
	#---
	def initComponentTree(component_count)
		if component_count != nil
			@isParent = []
			@isChild = []
			@seen = []

			for i in 1..component_count
				@isParent[i] = false
				@isChild[i] = false
			end

			for i in 1..component_count
				if @document["component_#{i}_children_isim"] != nil
					@isParent[i] = true
					@document["component_#{i}_children_isim"].each do |j|
						@isChild[j] = true
					end
				end
			end
		end
		return nil
	end

	#-------------------------
	# /COMPONENT TREE METHODS
	#-------------------------

end
