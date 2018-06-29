require "base64"
require "openssl"

module DamsObjectsHelper
  include Dams::ControllerHelper
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

  def field_mapping_note(note_key, note_type)
    data_arr=[]
    index = getComponentIndex
    fieldData = @document["#{index}note_json_tesim"]

     if fieldData != nil
       fieldData.each do |datum|
        note = JSON.parse(datum)
        if note[note_key] == note_type
          data_arr.push(note['value'])
        end
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
      data_arr=[]
    end

    def getFormat
       data_arr=[]
    end


    def getDescription
       data_arr = field_mapping_note("type","abstract")
    end
    
    def getRelation
       data_arr=[]
       fieldData=getFieldData('collection_json_tesim')
       
       # implementation for relation mapping
    end

    #Need refactor code when MADS implementation is done.
    def getCoverage
       data_arr=[]
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
       data_arr = field_mapping_note("displayLabel","ARK")
    end

   #dc:publisher
   def getPublisher
      data_arr = field_mapping_note("type","publication")
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

  def render_file (params)
    component = params[:component]
    quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document, :quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
    end
  end

  #---
  # render_file_use
  #---
  def render_file_use( params )
    files = render_file (params)
   
    file_info = files[:service]
    if file_info != nil
      use = file_info['use'].first
    end
  end

  #---
  # render_service_file
  #---
  def render_service_file( params )
    files = render_file (params)

    service_file = files[:service]
    if service_file != nil
      services=service_file["id"]
    end
  end

  #---
  # render_display_file
  #---
  def render_display_file( params )
    files = render_file (params)

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
        file = "#{i}_#{file}" if file != 'no_display'
      end
      return file
    end

	#---
	# Get the service file id value from the component's 'files_tesim' value. Replaces 'render_service_file'.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file id value
	# @author David T., hweng
	#---

 def required_file_use?(param)
   (param.end_with?("document-service")||param.end_with?("video-service")||param.end_with?("audio-service"))
 end

 def file_use(parameters, types)
   fieldData = file_data(parameters)
    result = nil

    if fieldData != nil
      fieldData.each do |datum|
        files = JSON.parse(datum)
        if files["use"].end_with?("-service")
          result = files[types]
          if required_file_use?(files["use"])
            break
          end
        end
      end
    end
    return result
 end

	def grabServiceFile(parameters={})
    file_use(parameters,"id")
	end

  def grabFileUse(parameters={})
    file_use(parameters,"use")
  end

  def file_data(parameters)
    p = {:componentIndex=>nil}.merge(parameters)
    componentIndex = p[:componentIndex]

    prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
    fieldData = @document["#{prefix}files_tesim"]
  end

	#---
	# Get the source file id value from the component's 'files_tesim' value.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file id value
	# @author escowles, hweng
	#---
	def grabSourceFile(parameters={})
		fieldData = file_data(parameters)
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
    fieldData = file_data(parameters)
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
				icon = 'glyphicon glyphicon-picture'
			when 'audio'
				icon = 'glyphicon glyphicon-volume-up'
			when 'video'
				icon = 'glyphicon glyphicon-film'
			when 'no-files'
				icon = 'glyphicon glyphicon-stop'
			else
				icon ='glyphicon glyphicon-file'
		end
		return icon
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
    concat "<i class='#{iconCSS} node-icon'></i> <button type='button' id='#{btnID}' data-index='#{index}' class='btn btn-small btn-link #{btnCSS}' #{btnAttrForFiles}>#{btnTitle}</button>".html_safe
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

    # load key from environment variable
    key = ENV.fetch('APPS_DHH_STREAMING_KEY') {'xxxxxxxxxxxxxxxx'}
    
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

  #---
  # Builds Wowza Secure Token
  #
  # @param field_data "files_tesim" data (JSON)
  # @param obj_id Object ID (String)
  # @param cmp_id Component ID (String)
  # @param base_url (String)
  # @return string or nil
  # @author Vivian
  #---

  def secure_token(field_data, obj_id, cmp_id, base_url)
    file_name = audio_video_file_name(field_data, cmp_id)
    return nil unless file_name
    end_time = secure_token_end_time
    token_hash = secure_token_hash(end_time, file_name, obj_id, base_url)
    "#{Rails.configuration.secure_token_name}endtime=#{end_time}&#{Rails.configuration.secure_token_name}hash=#{token_hash}".html_safe
  end

  #---
  # Builds Wowza Token Hash
  #
  # @param file_name (String)
  # @param end_time (Integer)
  # @param obj_id (String)
  # @param base_url (String)
  # @return string
  #---

  def secure_token_hash(end_time, file_name, obj_id, base_url)
    token_params = []
    token_params << Rails.configuration.secure_token_secret
    token_params << "#{Rails.configuration.secure_token_name}endtime=#{end_time}"
    token_params = token_params.sort
    stream = base_url.sub(%r{.*?\/}, '')
    obj_path = obj_id.scan(/.{1,2}/).join('/')
    hash_in = "#{stream}#{obj_path}/#{ark_naan}-#{obj_id}-#{file_name}?#{token_params.join('&')}"
    hash_out = Digest::SHA2.new(256).digest(hash_in.to_s)
    hash_out = Base64.encode64(hash_out).to_s.strip
    matchers = { '+' => '-', '/' => '_' }
    hash_out.gsub(/\+|\//) { |match| matchers[match] }
  end

  #---
  # Builds Wowza Secure Token Base URL
  #
  # @param field_data "files_tesim" data (JSON)
  # @param obj_id Object ID (String)
  # @param cmp_id Component ID (String)
  # @param base_url (String)
  # @return string or nil
  #---

  def secure_token_base_url(field_data, obj_id, cmp_id, base_url)
    file_name = audio_video_file_name(field_data, cmp_id)
    return nil unless file_name
    obj_path = obj_id.scan(/.{1,2}/).join('/')
    "#{base_url}#{obj_path}/#{ark_naan}-#{obj_id}-#{file_name}".html_safe
  end

  #---
  # Get file name
  #
  # @param field_data "files_tesim" data (JSON)
  # @param cmp_id Component ID (String)
  # @return string or nil
  #---

  def audio_video_file_name(field_data, cmp_id)
    return nil unless field_data
    field_data.each do |datum|
      files = JSON.parse(datum)
      if files['use'] == 'audio-service' || files['use'] == 'video-service'
        file_name = cmp_id + '-' + files['id']
        return file_name
      end
    end
  end

  def ark_naan() Rails.configuration.id_namespace.sub(%r{.*ark:\/}, '')[0..4] end

  #---
  # Creates Wowza Token End Time
  #
  # @return Integer
  #---

  def secure_token_end_time
    Time.zone = 'America/Los_Angeles'
    Time.now.to_i + 48.hours
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
  # Check to see if an object has a "metadataDisplay or localDisplay otherRights"
  #
  # @return An HTML string if an object has a "metadataDisplay or localDisplay otherRights", nil otherwise
  #---

  def grab_access_text(document)
    out = []
    data = rights_data document
    return nil unless metadata_display?(data) && current_user.nil?
    out << content_tag(:h3, 'Restricted View')
    out << content_tag(:p, get_attribution_note(document['otherNote_json_tesim']))
    safe_join(out)
  end

  def get_attribution_note(data)
    result = 'Content not available. Access may granted for research purposes at the discretion of the UC San Diego Library. For more information please contact the '
    program_email = { 'Digital Library Development Program' => 'dlp@ucsd.edu', 'Special Collections & Archives' => 'spcoll@ucsd.edu', 'Research Data Curation Program' => 'research-data-curation@ucsd.edu'}
    return result unless data
    data.each do |datum|
      note = JSON.parse(datum)
      if note['type'].start_with?('local attribution')
        program = note['value'].split(', ').first
        result += "#{program} at #{program_email[program]}"
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
