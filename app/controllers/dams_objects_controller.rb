require 'net/http'
require 'json'

class DamsObjectsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  #skip_load_resource :only => :show
  skip_load_and_authorize_resource :only => [:show, :zoom, :data_view]
  DamsObjectsController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    # update session counter, then redirect to URL w/o counter param
    if params[:counter]
      session[:search][:counter] = params[:counter]
      redirect_to dams_object_path(params[:id])
      return
    end

    # import solr config from catalog_controller and setup next/prev docs
    @blacklight_config = CatalogController.blacklight_config
    setup_next_and_previous_documents

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    @rdfxml = @document['rdfxml_ssi'] if !@document.nil?
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end

    # enforce access controls
    if can? :show, @document
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
      end
    elsif !@document.nil? && @document['discover_access_group_ssim'].include?("public")
      respond_to do |format|
        format.html { render :metadata }
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
      end
    else
      authorize! :show, @document # 403 forbidden
    end
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsObject"', :rows => 100 )
  end
  def zoom
    # check ip for unauthenticated users
    if current_user == nil
      current_user = User.anonymous(request.ip)
    end

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )

    # enforce access controls
    authorize! :show, @document

    @object = params[:id]
    @component = params[:cmp]

    render layout: 'minimal'
  end


  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################


  def new
    @dams_object.title.build
    @dams_object.title.first.elementList.subTitleElement.build
    @dams_object.title.first.hasVariant.build
    @dams_object.title.first.hasTranslationVariant.build
    @dams_object.title.first.hasAbbreviationVariant.build
    @dams_object.title.first.hasAcronymVariant.build
    @dams_object.title.first.hasExpansionVariant.build
    @dams_object.date.build
    @dams_object.language.build
    #@dams_object.language.first.scheme.build
    @dams_object.note.build
    @dams_object.scopeContentNote.build
    @dams_object.custodialResponsibilityNote.build
    @dams_object.preferredCitationNote.build
    @dams_object.relatedResource.build
    @dams_object.cartographics.build
    @dams_object.complexSubject.build
    #@dams_object.builtWorkPlace.build
    #@dams_object.culturalContext.build
    #@dams_object.function.build    
    @dams_object.genreForm.build
    @dams_object.geographic.build
    @dams_object.iconography.build    
    @dams_object.occupation.build
    #@dams_object.scientificName.build
    #@dams_object.stylePeriod.build    
    #@dams_object.technique.build   
    @dams_object.topic.build    
    @dams_object.temporal.build     
	@dams_object.name.build
    @dams_object.personalName.build    
    @dams_object.corporateName.build   
    @dams_object.conferenceName.build    
    @dams_object.familyName.build
    @dams_object.unit.build
    @dams_object.assembledCollection.build    
    @dams_object.provenanceCollection.build
    @dams_object.provenanceCollectionPart.build
    @dams_object.copyright.build
    @dams_object.license.build    
    @dams_object.statute.build
    @dams_object.rightsHolderPersonal.build
    @dams_object.rightsHolderCorporate.build
    @dams_object.rightsHolderConference.build
    @dams_object.rightsHolderFamily.build
    @dams_object.rightsHolderName.build
    #@dams_object.otherRights.build
    @dams_object.relationship.build
    @dams_object.relationship.first.role.build
    @dams_object.relationship.first.personalName.build
    @dams_object.relationship.first.name.build
    @dams_object.relationship.first.corporateName.build
    @dams_object.relationship.first.conferenceName.build
    @dams_object.relationship.first.familyName.build

                        
  	@mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
  	@mads_complex_subjects << "Create New Complex Subject"
  	@dams_units = get_objects_url('DamsUnit','unit_name_tesim') 	
  	@dams_assembled_collections = get_objects_url('DamsAssembledCollection','title_tesim')
    @dams_assembled_collections << "Create New Assembled Collection"
  	@dams_provenance_collections = get_objects_url('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects_url('MadsLanguage','name_tesim')
  	@mads_languages << "Create New Language"
  	@dams_copyrights = get_objects_url('DamsCopyright','status_tesim')
  	@dams_statutes = get_objects_url('DamsStatute','citation_tesim')
  	@dams_other_rights = get_objects('DamsOtherRight','note_tesim')
  	@dams_licenses = get_objects_url('DamsLicense','note_tesim')
  	@dams_personal_names = get_objects_url('MadsPersonalName','name_tesim')
  	@dams_corporate_names = get_objects_url('MadsCorporateName','name_tesim')
  	@dams_family_names = get_objects_url('MadsFamilyName','name_tesim')
  	@dams_conference_names = get_objects_url('MadsConferenceName','name_tesim')
  	@dams_provenance_collection_parts=get_objects_url('DamsProvenanceCollectionPart','title_tesim')
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
  	@dams_related_resources =  get_related_resource_url('DamsRelatedResource','type_tesim','relatedResourceDescription_tesim')
  	@dams_related_resources << "Create New Related Resource"
  	

	
  end
  
  def edit
    @dams_object = DamsObject.find(params[:id])
    
	#@mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
	@mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
	@mads_complex_subjects << "Create New Complex Subject"
	@dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
	@provenance_collection_part_id = @dams_object.provenanceCollectionPart.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.provenanceCollectionPart.nil?
	@dams_units = get_objects('DamsUnit','unit_name_tesim')
  	@dams_assembled_collections = get_objects_url('DamsAssembledCollection','title_tesim')
    @dams_assembled_collections << "Create New Assembled Collection"
  	@dams_provenance_collections = get_objects('DamsProvenanceCollection','title_tesim')
  	@mads_languages =  get_objects_url('MadsLanguage','name_tesim')
  	@mads_languages << "Create New Language"
  	@mads_authorities = get_objects('MadsAuthority','name_tesim')
  	@dams_copyrights = get_objects('DamsCopyright','status_tesim')
  	@dams_statutes = get_objects('DamsStatute','citation_tesim')
  	@dams_other_rights = get_objects('DamsOtherRight','note_tesim')
  	@dams_licenses = get_objects('DamsLicense','note_tesim')
  	@dams_rightsHolders = get_objects('MadsPersonalName','name_tesim')
  	@dams_related_resources =  get_related_resource_url('DamsRelatedResource','type_tesim','relatedResourceDescription_tesim')
  	@dams_related_resources << "Create New Related Resource"
  	  	 	
  	@unit_id = @dams_object.unit.to_s.gsub(/.*\//,'')[0..9]
  	#@assembled_collection_id = @dams_object.assembledCollectionURI.to_s.gsub(/.*\//,'')[0..9]
  	#@provenance_collection_id = @dams_object.provenanceCollectionURI.to_s.gsub(/.*\//,'')[0..9]
  	
  	@language_id = @dams_object.language.to_s.gsub(/.*\//,'')[0..9]
  	
  	@copyright_id = @dams_object.copyrights.pid if !@dams_object.copyrights.nil?
  	@statute_id = @dams_object.statutes.pid if !@dams_object.statutes.nil?
  	@otherRight_id = @dams_object.otherRights.pid if !@dams_object.otherRights.nil?
  	@license_id = @dams_object.licenses.pid if !@dams_object.licenses.nil?
  	#@rightsHolder_id = @dams_object.rightsHolders.first.pid if !@dams_object.rightsHolders.first.nil?
  	 	
  	@simple_subject_type = get_simple_subject_type(@dams_object) 	
  	@dams_simple_subjects = get_objects(@simple_subject_type,'name_tesim')
  	#@simpleSubject_id = @dams_object.topic.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.topic.nil? 
  	@simpleSubject_id = get_simple_subject_id(@dams_object) 
    @creator_id = get_name_id(@dams_object)
  	#@complexSubject_id = Rails.configuration.id_namespace + @dams_object.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.subject.nil?
  	@complexSubject_id = @dams_object.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_object.subject.nil?
	#@simpleSubjectValue = get_simple_subject_value(@dams_object)
	  
	@creator_type = get_name_type(@dams_object)
  	@simple_names = get_objects("Mads#{@simple_name_type}",'name_tesim') 	
  	@simple_name_value = get_name_value(@dams_object)
  	 
  	@dams_object.collections.each do |col|
  		if(col.class == DamsAssembledCollection)	
  			@assembled_collection_id = col.pid
  		elsif (col.class == DamsProvenanceCollection)
  			@provenance_collection_id = col.pid
  		end  			
  	end
    @creators = get_creators(@dams_object)
    @simpleSubjects = get_simple_subjects(@dams_object) 
	@relationships = get_relationships(@dams_object)
	@rHolders = get_rights_holders(@dams_object)
	

  end
  
  def create   
    has_file = "false"  
    #collectionsId = params[:dams_object][:assembledCollection_attributes]
 
    # Handling autocompleted field for data returned from remote website (LOC, etc.)
    # create Mads/Dams records and push uri to obj param list.

    @dams_object = DamsObject.new
       if !params["dams_object"].empty?
         hash_of_param = params["dams_object"]
          
         hash_of_param.each do |k, v|

           arr_of_attributes = ["builtWorkPlace_attributes", "culturalContext_attributes", "function_attributes", "genreForm_attributes", "geographic_attributes", "iconography_attributes", "occupation_attributes", "scientificName_attributes", "stylePeriod_attributes", "technique_attributes", "temporal_attributes", "topic_attributes" ]
           
           if arr_of_attributes.include?(k)              
              
              sub_type = k[0, k.index('_')]
              sub_type = sub_type[0, 1].capitalize + sub_type[1..-1]
              hash_of_value = v
              
              hash_of_value.each do |key, sub|
                
                 if sub[:id]!= nil

                    value = sub[:id]
             
                    if /loc:/.match(value)
                      
                      name = value[value.index('_')+7, value.length-1]
                      element_value = name
                      scheme_id = "http://library.ucsd.edu/ark:/20775/bd9386739x"
                      element_attributes = sub_type[0, 1].downcase + sub_type[1..-1] +"Element_attributes"
                      sub_hash = {
                        
                        "name" => name, 
                         element_attributes =>
                         {"0" => {"elementValue" => element_value }},
                         "scheme_attributes"=>{"0" => {"id" => scheme_id}}
                         
                      }
                     
                     class_name = get_class_name(sub_type)
                     class_ref = class_name.constantize
                     obj = class_ref.new
                     obj.attributes = sub_hash
                     obj.save

                     # add the uri to obje parameter list
                     uri = "#{Rails.configuration.id_namespace}#{obj.pid}"
                     sub[:id]= uri
     
                   end
                end
                
                if sub[:id]== nil && sub[:label]!= nil
                  name = sub[:label]
                  element_value = name
                  scheme_id = "http://library.ucsd.edu/ark:/20775/bd9386739x"
                  element_attributes = sub_type[0, 1].downcase + sub_type[1..-1] +"Element_attributes"

                  sub_hash = {
                        "name" => name, 
                         element_attributes =>
                         {"0" => {"elementValue" => element_value }},
                         "scheme_attributes"=>{"0" => {"id" => scheme_id}}
                      }
                     
                     class_name = get_class_name(sub_type)
                     class_ref = class_name.constantize
                     obj = class_ref.new
                     obj.attributes = sub_hash
                     obj.save

                     # add the uri to obje parameter list
                     uri = "#{Rails.configuration.id_namespace}#{obj.pid}"
                     sub[:id]= uri
                end
             end
           end
         end
      end
   

    @dams_object.attributes = params[:dams_object] 

    
  	if @dams_object.save 
        flash[:notice] = "Object has been saved"

        @dams_object.reload
        

        # check for file upload
        if params[:file]
          file_status = attach_file( @dams_object, params[:file] )
          flash[:alert] = file_status[:alert] if file_status[:alert]
          flash[:deriv] = file_status[:deriv] if file_status[:deriv]

          derivative_status = create_derivatives( @dams_object.pid, params[:file], request.fullpath )
          flash[:alert] = derivative_status[:alert] if derivative_status[:alert]
          flash[:notice] = derivative_status[:alert] if derivative_status[:notice]
          has_file = "true"
        end

        # reindex the record
        begin
          @dams_object.send :update_index
		 # collectionsId.each do |colId|
		 #	if colId.class == Array and colId.size > 1
		 #	  collectionObj = DamsAssembledCollection.find( colId[1].to_s.gsub(/.*\//,'')[0..9] )
		 #	  if (!collectionObj.nil?)
		 #	    collectionObj.send :update_index
		 #	  end	
		 #	end    
		 # end
          colObjects = Array.new
          get_colletion_objects(params[:dams_object][:assembledCollection_attributes],colObjects,DamsAssembledCollection)
		  get_colletion_objects(params[:dams_object][:provenanceCollection_attributes],colObjects, DamsProvenanceCollection)
          get_colletion_objects(params[:dams_object][:provenanceCollectionPart_attributes],colObjects, DamsProvenanceCollectionPart)

          if(!colObjects.nil?)
	        colObjects.each do |colObj|
		  	  colObj.send :update_index
		  	end
		  end		           
        rescue Exception => e
          logger.warn "Error reindexing #{@dams_object.pid}: #{e}"
        end
		if has_file == "false"
  			redirect_to @dams_object
  		end
  		
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
    
    if has_file == "true"
      @obj = @dams_object.id
      #update solr index
      @fobj = DamsObject.find( @obj )
      @fobj.send :update_index

      redirect_to dams_object_path @obj    	
    end
  end
  
  def update
  	@dams_object.title.clear
  	@dams_object.date.clear
  	@dams_object.language.clear
    @dams_object.note.clear
    @dams_object.scopeContentNote.clear
    @dams_object.custodialResponsibilityNote.clear
    @dams_object.preferredCitationNote.clear
    #@dams_object.relatedResource.clear
    @dams_object.cartographics.clear
    @dams_object.complexSubject.clear
    @dams_object.builtWorkPlace.clear
    @dams_object.culturalContext.clear
    @dams_object.function.clear    
    @dams_object.genreForm.clear
    @dams_object.geographic.clear
    @dams_object.iconography.clear    
    @dams_object.occupation.clear
    @dams_object.scientificName.clear
    @dams_object.stylePeriod.clear    
    @dams_object.technique.clear   
    @dams_object.topic.clear
    @dams_object.temporal.clear
	@dams_object.name.clear
    @dams_object.personalName.clear    
    @dams_object.corporateName.clear   
    @dams_object.conferenceName.clear    
    @dams_object.familyName.clear
    @dams_object.unit.clear
    @dams_object.assembledCollection.clear   
    @dams_object.provenanceCollection.clear
    @dams_object.provenanceCollectionPart.clear
    @dams_object.copyright.clear
    @dams_object.license.clear  
    @dams_object.statute.clear
    @dams_object.relationship.clear
    @dams_object.rightsHolderPersonal.clear
    @dams_object.rightsHolderCorporate.clear
    @dams_object.rightsHolderConference.clear
    @dams_object.rightsHolderFamily.clear
    @dams_object.rightsHolderName.clear    
	has_file = "false"
	#collectionsId = params[:dams_object][:assembledCollectionURI]
     
     
      # Handling autocompleted field for data coming from remote website such as LOC, and mapping to Mads/Dams classes.
       if params["dams_object"]["simpleSubjectURI"]!= nil && (!params["dams_object"]["simpleSubjectURI"].empty?)
         hash_of_param = params["dams_object"]["simpleSubjectURI"]
          
         hash_of_param.each_with_index do |value, index|
           
           # Getting data from external resouce and mapping to Mads or Dams class
           if /loc:/.match(value)
 
              sub_type = nil
              # subject type => Topic, BuiltWorkPlace, ScientificName etc.
              # if !params["dams_object"]["subjectType"].empty?
              #    sub_type = params["dams_object"]["subjectType"][index]
              # end
              sub_type = value[4, value.index('_') - 4]
              sub_type = "Topic" if sub_type == nil

              name = value[value.index('_')+7, value.length-1]
              element_value = name
              scheme_id = "http://library.ucsd.edu/ark:/20775/bd9386739x"
              element_attributes = sub_type[0, 1].downcase + sub_type[1..-1] +"Element_attributes"
              sub_hash = {
                
                "name" => name, 
                 element_attributes =>
                 {"0" => {"elementValue" => element_value }},
                 "scheme_attributes"=>{"0" => {"id" => scheme_id}}
                 
              }
             
             class_name = get_class_name(sub_type)
             
             class_ref = class_name.constantize
             obj = class_ref.new
             obj.attributes = sub_hash
             obj.save

              # add the uri to obje parameter list
              uri = "#{Rails.configuration.id_namespace}#{obj.pid}"
              hash_of_param[index]= uri
              
           end
         end
        end
      
    @dams_object.attributes = params[:dams_object]  
  	if @dams_object.save
        @dams_object.reload
       
        # check for file upload
        if params[:file]
          file_status = attach_file( @dams_object, params[:file] )
          flash[:alert] = file_status[:alert] if file_status[:alert]
          flash[:deriv] = file_status[:deriv] if file_status[:deriv]
          
          derivative_status = create_derivatives( @dams_object.pid, params[:file], request.fullpath )
          flash[:alert] = derivative_status[:alert] if derivative_status[:alert]
          flash[:notice] = derivative_status[:alert] if derivative_status[:notice]
          has_file = "true"
        end

        # reindex the record
        begin
          @dams_object.send :update_index
          colObjects = Array.new
          get_colletion_objects(params[:dams_object][:assembledCollectionURI],colObjects,DamsAssembledCollection)
		  get_colletion_objects(params[:dams_object][:provenanceCollectionURI],colObjects, DamsProvenanceCollection)
          get_colletion_objects(params[:dams_object][:provenanceCollectionPartURI],colObjects, DamsProvenanceCollectionPart)

          if(!colObjects.nil?)
	        colObjects.each do |colObj|
		  	  colObj.send :update_index
		  	end
		  end		  
        rescue Exception => e
          logger.warn "Error reindexing #{@dams_object.pid}: #{e}"
        end
        if has_file == "false"
  			redirect_to @dams_object, notice: "Successfully updated object"
  		end
    else
      flash[:alert] = "Unable to save object"
      render :edit
    end
    
    if has_file == "true"
      @obj = @dams_object.id
      #update solr index
      @fobj = DamsObject.find( @obj )
      @fobj.send :update_index

      redirect_to dams_object_path @obj    	
    end    
  end
  
  def data_view
  	data = get_html_data ( params[:id] )
    render :text => data
  end 


  def get_class_name(name)
    arr_of_dams = ["BuiltWorkPlace", "CulturalContext", "Function", "Iconography", "StylePeriod", "Technique", "ScientificName" ]
  
    if arr_of_dams.include?(name)
      class_name = "Dams" + name
    else
      class_name = "Mads" + name 
    end
  end
end
