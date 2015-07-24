require 'net/http'
require 'json'

class GetDataController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper

## Returns an array of JSON objects with id and label
 #[{"id":"http://library.ucsd.edu/ark:/20775/xx00000143","label":"test_name1"},{"id":"http://library.ucsd.edu/ark:/20775/xx00000147","label":"test_name2"}]
 # http://localhost:3000/get_data/get_dams_data/get_dams_data?q=Topic
  
  def get_dams_data

  	if(!params[:q].nil? && params[:q] != '' && params[:q] == 'Topic')
		@docs = get_objects_json('MadsTopic','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'BuiltWorkPlace')
		@docs = get_objects_json('DamsBuiltWorkPlace','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'CulturalContext')
		@docs = get_objects_json('DamsCulturalContext','name_tesim')		
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Function')
		@docs = get_objects_json('DamsFunction','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'GenreForm')
		@docs = get_objects_json('MadsGenreForm','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Geographic')
		@docs = get_objects_json('MadsGeographic','name_tesim')	
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Iconography')
		@docs = get_objects_json('DamsIconography','name_tesim')		
	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'CommonName')
        @docs = get_objects_json('DamsCommonName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'ScientificName')
		@docs = get_objects_json('DamsScientificName','name_tesim')	
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Technique')
		@docs = get_objects_json('DamsTechnique','name_tesim')	
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Temporal')
		@docs = get_objects_json('MadsTemporal','name_tesim')
	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'StylePeriod')
		@docs = get_objects_json('DamsStylePeriod','name_tesim')		
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'CorporateName')
		@docs = get_objects_json('MadsCorporateName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'PersonalName')
		@docs = get_objects_json('MadsPersonalName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'ConferenceName')
		@docs = get_objects_json('MadsConferenceName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'FamilyName')
		@docs = get_objects_json('MadsFamilyName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Name')
		@docs = get_objects_json('MadsName','name_tesim')
  	elsif(!params[:q].nil? && params[:q] != '' && params[:q] == 'Occupation')
		@docs = get_objects_json('MadsOccupation','name_tesim')																													
	else
		@docs = get_objects_json('MadsTopic','name_tesim')
	end

	render json: @docs
  	
  end


  def get_linked_data 	
  	#http://localhost:3000/get_data/get_data/get_data?q=dog&fl=suggestall
	uri = URI('http://fast.oclc.org/fastSuggest/select')
    if(!params[:q].nil? && params[:q] != '' && !params[:fl].nil? && params[:fl] != '')		
		#res = Net::HTTP.post_form(uri, 'q' => 'suggestall :cats', 'fl' => 'suggestall', 'wt' => 'json')
		res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json')
		json = JSON.parse(res.body)
		if(json.fetch("response").fetch("numFound") > 0 && json.fetch("response").fetch("numFound") < 1000)
			res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json', 'rows' => json.fetch("response").fetch("numFound"), 'sort' => 'usage desc')
			json = JSON.parse(res.body)		
		elsif(json.fetch("response").fetch("numFound") > 0 && json.fetch("response").fetch("numFound") > 1000)
			res = Net::HTTP.post_form(uri, 'q' => "#{params[:fl]} :#{params[:q]}", 'fl' => params[:fl], 'wt' => 'json', 'rows' => 1000, 'sort' => 'usage desc')
			json = JSON.parse(res.body)							
		end
		@jdoc = json.fetch("response").fetch("docs")
		render :layout => false
	else
		res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => 1000)	
		json = JSON.parse(res.body)
		@jdoc = json.fetch("response").fetch("docs")
		render :layout => false
	end
  end

  def get_creator	

  	@formType = params[:formType]
  	@fieldName = params[:fieldName]
  	@label = params[:q]
  	@fieldId = params[:fieldId]
  	@selectedValue = params[:selectedValue]
    @selectedLabel = params[:selectedLabel]
    @names = ""
  	
  	render :layout => false
  end
 
 def get_subject	
  	#http://localhost:3000/get_data/get_subject/get_subject?q=Topic&formType=dams_object&fieldName=simpleSubjectURI&label=Subject

	@formType = params[:formType]
	@fieldName = params[:fieldName]
	@label = params[:q]
	@fieldId = params[:fieldId]
	@selectedValue = params[:selectedValue]

	@selectedLabel = params[:selectedLabel]
	#@subjects = "Create New #{@label}"
  @subjects = ""

	render :layout => false
  end

 def get_name   
    #http://localhost:3000/get_data/get_name/get_name?q=PersonalName&formType=dams_object
    type = nil;
    if(!params[:q].nil? && params[:q] != '' && (params[:q].include? 'Corporate'))
      type = 'MadsCorporateName'    
    elsif(!params[:q].nil? && params[:q] != '' && (params[:q].include? 'Personal'))
      type = 'MadsPersonalName'     
    elsif(!params[:q].nil? && params[:q] != '' && (params[:q].include? 'Conference'))
      type = 'MadsConferenceName' 
    elsif(!params[:q].nil? && params[:q] != '' && (params[:q].include? 'Family'))
      type = 'MadsFamilyName'
    elsif(!params[:q].nil? && params[:q] != '' && (params[:q].include? 'Name'))
      type = 'MadsName'           
  else
    type = 'MadsName'
  end

  @names = get_objects_url(type,'name_tesim')
  @formType = params[:formType]
  @fieldName = params[:fieldName]
  @label = params[:q]
  @fieldId = params[:fieldId]
  @selectedValue = params[:selectedValue]
  
  @hasSelectedValue = "false" 
  if !@selectedValue.nil? and !@selectedValue.include? "null" and @names.to_s.include? @selectedValue
    @hasSelectedValue = "true"
  end

  if !@selectedValue.nil? and !@selectedValue.include? "null" and @hasSelectedValue.include? "false"    
    tmpNameObject = type.constantize.find(@selectedValue)
    if(!tmpNameObject.nil?)
      tmpArray = Array.new
      tmpArray << tmpNameObject.name.first
      tmpArray << Rails.configuration.id_namespace+@selectedValue         
      @names << tmpArray
    end
  end
  
  @names << "Create New #{@label}"
  @relationship = params[:relationship]
  if !@relationship.nil? and @relationship == "true"
    @mads_authorities = get_objects_url('MadsAuthority','name_tesim')
    @mads_authorities << "Create New Role"
    @selectedRole = params[:selectedRole]
  end
  render :layout => false
  end
  
  def get_ark 	
  	#http://localhost:8080/dams/api/next_id?count=1
  	#http://localhost:3000/get_data/get_ark/get_ark
	# build url to make damsrepo generate new ark
    user = ActiveFedora.fedora_config.credentials[:user]
    pass = ActiveFedora.fedora_config.credentials[:password]
    baseurl = ActiveFedora.fedora_config.credentials[:url]
    baseurl = baseurl.gsub(/\/fedora$/,'')
    url = "#{baseurl}/api/next_id?count=1"

    # call damsrepo
    response = RestClient::Request.new(
      :method => :post, :url => url, :user => user, :password => pass
    ).execute
	#json = JSON.parse(response.to_str)

    @ark = response.to_str
    @ark = @ark[61..70]
    render :layout => false
  end
 
  def get_new_objects
  	#http://localhost:3000/get_data/get_new_objects/get_new_objects
	@doc = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsObject" AND timestamp:[NOW-1DAY TO NOW]', :rows => '10000')
  	@objects = Array.new
  	@doc.each do |col| 
	  if col.class == Array
		col.each do |c|						  
		  if(c.key?("files_tesim") and c.fetch("files_tesim").to_s.include? ".tif")
			@objects << c.id+"/1.tif"
		  end
		end
	  end
	end
    render :layout => false
  end
          
  def show
	redirect_to :action => 'get_linked_data'
  end
end
