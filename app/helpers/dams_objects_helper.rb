require "base64"
require "openssl"

module DamsObjectsHelper

  #---
    # Openurl, embedded metadata support,
    # Get metadata from solr document, and parsing each field and produce openURL key-encoded value query strings.
    # create mapping from DAMS fields to dublin core fields
    # hweng@ucsd.edu
  #---
  def field_mapping(fieldName)
    data_arr=[]

    fieldData = getFieldData(fieldName)
     if fieldData != nil
      fieldData.each do |value|
        data_arr.push(value)
        end
     end
     data_arr
    end
  
 def getFieldData(fieldName)
       index = getComponentIndex
       fieldData = @document["#{index}#{fieldName}"]
 end

    def getComponentIndex
        index = (defined?(componentIndex)) ? "component_#{componentIndex}_" : ''
    end
    
    # Mapping from title_json_tesim, and concatenate as title_json_tesim.value:title_json_tesim.subTitle
    def getTitle
      data_arr=[]
      
      fieldData=getFieldData('title_json_tesim')
      title_value=''

       if fieldData != nil
         fieldData.each do |datum|
          title = JSON.parse(datum)
          if title['value'] != ''
             title_value = getFullTitle title
             if title['subtitle'] != ''
              title_value=title_value+ title['subtitle']
             end
            data_arr.push(title_value)
          end
        end
       end 
        data_arr
    end


    #Need to update 
    def getCreator
      # data_arr=[]
      # get creator list from names:personal
       fieldValue=field_mapping('name_tesim')
      #if fieldValue != nil && fieldValue != ''
      #  data_arr.push(fieldValue)
      # end
       
      # get creator list from corporateName_tesim
      # fieldValue=field_mapping('corporateName_tesim')
      # if fieldValue != nil && fieldValue != ''
      #  data_arr.push(fieldValue)
      # end
    end

    def getFormat
       data_arr=[]
       fieldData=getFieldData('note_json_tesim')
       format_value=''
       concat__note_value=''
       concat__form_value=''
       concat__extent_value=''

       
       if fieldData != nil
         fieldData.each do |datum|
          format = JSON.parse(datum)
          if format['displayLabel'] == 'Form'
            concat__form_value=format['value']
          elsif format['displayLabel'] == 'Extent'
            concat__extent_value=format['value']
          elsif format['displayLabel'] == 'Note'
            concat__note_value=format['value']
          end
         end

         if concat__note_value!=''
           format_value=concat__note_value
         elsif concat__form_value!=''
            format_value=concat__form_value
            if concat__extent_value!=''
             format_value=format_value+";"+concat__extent_value
            end
         end
         data_arr.push(format_value)
       end 
        data_arr
    end


    def getDescription
       data_arr=[]
       fieldData=getFieldData('note_json_tesim')

       if fieldData != nil
         fieldData.each do |datum|
          note = JSON.parse(datum)
          if note['type'] == 'abstract'
            data_arr.push(note['value'])
          end
          end
        end 
        data_arr
    end
    
    def getRelation
       data_arr=[]
       fieldData=getFieldData('collection_json_tesim')
       
       # implementation for relation mapping
    end

    #Need refactor code when MADS implementation is done.
    def getCoverage
       data_arr=[]
       fieldData=getFieldData('cartographics_json_tesim')
       coverage_value=''
       
       if fieldData != nil
         fieldData.each do |datum|
          coverage = JSON.parse(datum)
          if coverage['scale'] != ''
            coverage_value=coverage['scale']
            if coverage['projection'] != ''
              coverage_value=coverage_value+coverage['projection']
              if coverage['coordinates'] != ''
                coverage_value=coverage_value+coverage['coordinates']
              end
            end

            data_arr.push(coverage_value)
          end
         end
        end 
        data_arr
    end

    #Need refactor code when MADS implementation is done.
    def getSubject

       fieldValue=field_mapping('subject_tesim')
    end

    

    def getDate
       data_arr=[]
       index = getComponentIndex
       fieldData = @document["#{index}date_json_tesim"]
       
       if fieldData != nil
         fieldData.each do |datum|
          date = JSON.parse(datum)
          if date['value'] != ''
            data_arr.push(date['value'])
          end
          end
        end 
        data_arr
    end
    

    
    def getLanguage
        fieldValue=field_mapping('language_tesim')
    end

    def getIdentifier
       data_arr=[]
       index = getComponentIndex
     fieldData = @document["#{index}note_json_tesim"]

     if fieldData != nil
       fieldData.each do |datum|
          note = JSON.parse(datum)
          if note['displayLabel'] == 'ARK'
            data_arr.push(note['value'])
          end
       end
      end
     data_arr
    end

   #dc:publisher
   def getPublisher
       data_arr=[]
       fieldData=getFieldData('note_json_tesim')

       if fieldData != nil
         fieldData.each do |datum|
          note = JSON.parse(datum)
          if note['type'] == 'publication'
            data_arr.push(note['value'])
          end
          end
        end 
        data_arr
    end
    
    def getCopyright
       data_arr=[]
       index = getComponentIndex
     fieldData = @document["#{index}copyright_tesim"]
     if fieldData != nil
      fieldJSON = JSON.parse(fieldData.first)
        temp =fieldJSON['purposeNote']
        temp ='purposeNote: '+temp + ' '+'note: '+fieldJSON['note']
        data_arr.push(temp)
     end
     data_arr
    end
    
    def getFilesType
      ret = ""
      index = getComponentIndex
      fieldData = @document["#{index}files_tesim"]
      if fieldData != nil
        fieldData.each do |datum|
          files = JSON.parse(datum)
          if files['mimeType'].end_with?("pdf")
            ret = files['formatName']
          end
        end
      end
      ret
    end
   
   def export_as_openurl
        query_string = []
        query_string << "url_ver=Z39.88-2004&ctx_ver=Z39.88-2004&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc&rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator"
        field_map = {
          'title' => getTitle,
          'creator'=>getCreator,
          'subject'=>getSubject,
          'description'=>getDescription,
          'date'=>getDate,
          'format'=>getFormat,
          'language'=> getLanguage,
          'identifier'=>getIdentifier,
          #'coverage'=>getCoverage,
           'publisher'=>getPublisher,
           'rights'=> getCopyright
          
        }
        field_map.each do |kev, values|
          next if values.empty? or values.first.nil?
          values.each do |value|
            query_string << "rft.#{kev}=#{CGI::escape(value)}"
          end
        end
        query_string.join('&') unless query_string.blank?
    end

  #--
  # End of openURL implementation
  #    


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
    service_use = nil
    service_dim = 0
    service_json = nil
    display_dim  = 0
    display_json = nil
    if files != nil
      files.each{ |f|
        fjson = JSON.parse(f)
        fid = fjson["id"]
        use = fjson["use"]
        if use != nil
          use = use.first
        end
        qual = fjson["quality"]
        if qual != nil
          qualArr = qual.split("x")
          file_dim = qualArr.max { |a,b| a.to_i <=> b.to_i }.to_i
        end
        if type == nil || use.start_with?(type)
          if use != nil && use.end_with?("-service")
            if (service_json == nil || service_use.start_with?("image-") )
              service_json = fjson
              service_use = use
              service_dim = file_dim.to_i
            end
          elsif max_size == nil || file_dim == nil || file_dim.to_i < max_size
            if (display_json == nil || file_dim.to_i > display_dim) && use != nil && (not use.end_with?("-source") )
              display_json = fjson
              display_dim  = file_dim.to_i
            end
          end
        end
      }
    end
  
    # build file metadata hash
    info = Hash.new
    if ( service_json != nil )
      info[:service] = service_json
    end
    if ( display_json != nil )
      info[:display] = display_json
    end
    info
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
      use = file_info['use'].first
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
      services=service_file["id"]
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
      display=display_file["id"]
    else
      service_file = files[:service]
      if service_file != nil
        services=service_file["id"]
      
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

	#---
	# POST SOLR UPDATE REWRITES
	#---

	#---
	# Get the display file id value from the component's 'files_tesim' value. Replaces 'render_display_file'.
	#
	# @param quality (Optional) The quality of the display file. Possible values: 'icon', 'thumbnail', 'preview' (Default), 'large' and 'huge'
	# @param componentIndex (Optional) The component's index.
	# @return If found, returns a string that is the component's display file id value, otherwise returns 'no_display'
	# @author David T.
	#---
	def grabDisplayFile(parameters={})

		p = {:componentIndex=>nil,:quality=>'preview'}.merge(parameters)
		componentIndex = p[:componentIndex]
		validQualities = Set.new ['icon', 'thumbnail', 'preview', 'large', 'huge']
		quality = (validQualities.include? p[:quality].downcase) ? p[:quality].downcase : 'preview'

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = 'no_display'

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-#{quality}")
					result = files["id"]
					break
				end
			end
		end

		return result
	end

    def grabAnyDisplayFile
      file = grabDisplayFile
      component_count = @document[:component_count_isi] || 0
      i = 0
      while file == 'no_display' && i < component_count do
        i = i + 1
	    file = grabDisplayFile(componentIndex: i)
        file = "_#{i}_#{file}" if file != 'no_display'
      end
      return file
    end

	#---
	# Get the service file id value from the component's 'files_tesim' value. Replaces 'render_service_file'.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file id value
	# @author David T.
	#---
	def grabServiceFile(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-service")
					result = files["id"]
					if(files["use"].end_with?("document-service"))
						break
					end
				end
			end
		end

		return result
	end

	#---
	# Get the source file id value from the component's 'files_tesim' value.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file id value
	# @author escowles
	#---
	def grabSourceFile(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-source")
					result = files["id"]
					break
				end
			end
		end

		return result
	end



  def grabPDFFile(parameters={})

    p = {:componentIndex=>nil}.merge(parameters)
    componentIndex = p[:componentIndex]

    prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
    fieldData = @document["#{prefix}files_tesim"]
    result = nil

    if fieldData != nil
      fieldData.each do |datum|
        files = JSON.parse(datum)
        if files["use"].end_with?("document-service") || files["use"].end_with?("document-source")
          result = files["id"]
          break
        end
      end
    end

    return result
  end

	#---
	# Get the file use value from the component's 'files_tesim' value. Replaces 'render_file_use'.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
	# @author David T.
	#---
	def grabFileUse(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-service")
					result = files["use"]
					if(result == "document-service")
						break
					end
				end
			end
		end

		return result
	end

	#------------------------
	# COMPONENT TREE METHODS
	#------------------------

	#---
	# Get the object's title
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the title value for our object.
	# @author David T.
  # Updated by hweng@ucsd.edu to fix the label/title display issue.
	#---
	def grabTitle(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}title_json_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
        title = JSON.parse(datum)
        if !title['value'].blank?
            result = getFullTitle title
            break
        else
            result = title['name']
        end
      end
    else
      result = "Generic Component Title #{componentIndex}"
		end
      result
	end

	#---
	# Get the file type value from the component's file use value
	#
	# @param fileUse The component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
	# @return A string that is the file type value for our component.
	# @author David T.
	#---
	def grabFileType(fileUse)
		fileType = (fileUse) ? fileUse.split("-").first : 'no-files'
	end

	#---
	# Determines which Bootstrap icon glyph to use based on a component's file type.
	#
	# @param fileUse The component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
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

		fileUse = grabFileUse(:componentIndex=>index)
		btnAttrForFiles = "onClick='dp.COV.showComponent(#{index});'"
		btnID = "node-btn-#{index}"
		btnCSS = (fileUse) ? "node-file #{@firstButton}" : ''
		btnCSS += (@isParent[index]) ? ' node-parent' : ''
		iconCSS = (@isParent[index]) ? 'icon-chevron-down node-toggle' : grabIcon(fileUse)
		btnTitle = grabTitle(:componentIndex=>index)

		concat "<li>".html_safe
		concat "<i class='#{iconCSS} node-icon'></i> <button type='button' id='#{btnID}' class='btn btn-small btn-link #{btnCSS}' #{btnAttrForFiles}>#{btnTitle}</button>".html_safe

		# Display children if parent
		if (@isParent[index])

			concat "<ul class='unstyled node-container'>".html_safe
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

	#-------------------------------------------------------------------------------
	# The below is the new version of component tree display, 
  # which fixed the following probelms of old version tree display:
  # 1. the order issue: always display the nested parent-child nodes at bottom of the list.
  # 2. Display twice for the child node which is both at top level and nested level.
  # And separated the logic code from display code.
  #
  # by hweng@ucsd.edu
  #-------------------------------------------------------------------------------
  # @author listu@ucsd.edu
  # @date 04/14/2015
  # Updated note:
  # - Fixed the flataten/repeated components display problem when component tree depth > 2
  # - Fixed the missing </li> end tag for some of the components that may distort the tree displayed.
  #-------------------------------------------------------------------------------

  def init_Tree(components)
  end

  def display_tree(components)
    @checked = []
    if !components.nil? && !components.empty? 
      concat '<ul class="unstyled">'.html_safe
      components.each do |i|
          display_node i if @checked[i].nil? || !@checked[i]
      end
      concat '</ul>'.html_safe
    end
  end

def display_node(index)
    children_list = @document["component_#{index}_children_isim"]
    concat "<li>".html_safe
    if children_list.nil? || children_list.empty?
      render_node_HTML(index, false )
    else
      render_node_HTML(index, true)

      concat "<ul class='unstyled node-container'>".html_safe
      children_list.each do |value|
        display_node(value.to_i)
      end
      concat "</ul>".html_safe
    end
    concat "</li>".html_safe
    @firstButton = nil
  end

  def render_node_HTML(index, is_parent_node)
    @checked[index]= true
    fileUse = grabFileUse(:componentIndex=>index)
    btnAttrForFiles = "onClick='dp.COV.showComponent(#{index});'"
    btnID = "node-btn-#{index}"
    btnCSS = (fileUse) ? "node-file #{@firstButton}" : ''
    btnCSS += is_parent_node ? ' node-parent' : ''
    iconCSS = is_parent_node ? 'icon-chevron-down node-toggle' : grabIcon(fileUse)
    btnTitle = grabTitle(:componentIndex=> index)
    concat "<i class='#{iconCSS} node-icon'></i> <button type='button' id='#{btnID}' class='btn btn-small btn-link #{btnCSS}' #{btnAttrForFiles}>#{btnTitle}</button>".html_safe
  end

  def listComponents (component_map)
    components = component_map.nil? ? [] : component_map.first.dup.gsub!(':', ',').gsub!(/[\[\]{}"]/, '').split(',')
    components.reject { |c| c.blank? }.map! { |i| i.to_i } 
  end

  #-------------------------------
  # End of Component Tree Display
  #-------------------------------


  #-----------
  # STREAMING
  #-----------

  #---
  # Builds Wowza URL
  #
  # @param fieldData "files_tesim" data (JSON)
  # @param objid Object ID (string)
  # @param cmpid Component ID (string)
  # @return string or nil
  # @author David T.
  #---

  def grabWowzaURL(fieldData,objid,cmpid)
    if fieldData != nil
      fieldData.each do |datum|
        files = JSON.parse(datum)
        if files['use'] == 'audio-service' || files['use'] == 'video-service'
          fileid = cmpid + '-' + files['id']
          encrypted = encrypt_stream_name( objid, fileid, request.ip )
          return Rails.configuration.wowza_baseurl + encrypted
        end
      end
    else
      nil
    end
  end


  ## video stream name encryption
  def encrypt_stream_name( pid, fid, ip )

    # random nonce
    nonce=rand(36**16).to_s(36)
    while nonce.length < 16 do
      nonce += "x"
    end

    # load key from file
    key= File.read Rails.configuration.wowza_directory + 'streaming.key'

    # encrypt
    str="#{pid} #{fid} #{ip}"
    cipher = OpenSSL::Cipher::AES.new(128,:CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = nonce
    enc = cipher.update(str) + cipher.final

    # base64-encode
    b64 = Base64.encode64 enc
    b64 = b64.gsub("+","-").gsub("/","_").gsub("\n","")
    "#{nonce},#{b64}"
  end


  #------------
  # /STREAMING
  #------------

  #---
  # Check to see if an object has a "Restricted Notice"
  #
  # @return An HTML string if a restricted notice is present, nil otherwise
  #---

  def grabRestrictedText(data)

    result = nil

    if data != nil
      data.each do |datum|

        note = JSON.parse(datum)

        if note['value'].start_with?('Culturally sensitive content: ', 'Copyrighted content: ','Embargoed content: ')
          note_array = note['value'].split(': ')
          result = "<h3>#{note_array[0].titleize}</h3><p>#{note_array[1]}</p>".html_safe
        end

        # Add 'View Content' button to certain cases
        if note['value'].start_with?('Culturally sensitive content: ')
          result += '<p>Would you like to view this content?</p><button type="button" id="view-masked-object" class="btn btn-primary btn-mini pull-right">Yes, I would like to view this content.</button>'.html_safe
        end

      end
    end

    result

  end

  #---
  # Normalized rdf view from DAMS4 REST API
  #---

  def normalized_rdf_path( pid )
    # get REST API url from AF config
    baseurl = ActiveFedora.fedora_config.credentials[:url].gsub(/\/fedora$/,'')
    "#{baseurl}/api/objects/#{pid}/transform?recursive=true&xsl=normalize.xsl"
  end

  def rdf_edit_url (pid)
     proxy_url = ActiveFedora.fedora_config.credentials[:proxy]
     "#{proxy_url.nil? ? '' : proxy_url}/damsmanager/rdfImport.do?ark=#{pid}"
  end
end
