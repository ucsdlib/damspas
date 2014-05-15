require 'net/http'
require 'json'

class DamsProvenanceCollectionsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only =>[:show, :index]
  after_action 'audit("#{@dams_provenance_collection.id}")', :only => [:create, :update]

  def show
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    if @document.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    @rdfxml = @document['rdfxml_ssi']
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
      format.rdf { render xml: @rdfxml }
    end
  end

  def new

    @dams_provenance_collection.title.build
    @dams_provenance_collection.title.first.elementList.subTitleElement.build
    @dams_provenance_collection.title.first.hasVariant.build
    @dams_provenance_collection.title.first.hasTranslationVariant.build
    @dams_provenance_collection.title.first.hasAbbreviationVariant.build
    @dams_provenance_collection.title.first.hasAcronymVariant.build
    @dams_provenance_collection.title.first.hasExpansionVariant.build
    @dams_provenance_collection.date.build
    @dams_provenance_collection.language.build
    @dams_provenance_collection.unit.build
        
    @dams_provenance_collection.note.build
    @dams_provenance_collection.scopeContentNote.build
    @dams_provenance_collection.custodialResponsibilityNote.build
    @dams_provenance_collection.preferredCitationNote.build
    @dams_provenance_collection.relatedResource.build
    
    @dams_provenance_collection.complexSubject.build
    @dams_provenance_collection.builtWorkPlace.build
    @dams_provenance_collection.culturalContext.build
    @dams_provenance_collection.function.build    
    @dams_provenance_collection.genreForm.build
    @dams_provenance_collection.geographic.build
    @dams_provenance_collection.iconography.build    
    @dams_provenance_collection.occupation.build
    @dams_provenance_collection.scientificName.build
    @dams_provenance_collection.stylePeriod.build    
    @dams_provenance_collection.technique.build   
    @dams_provenance_collection.topic.build    
    @dams_provenance_collection.temporal.build     
    @dams_provenance_collection.name.build
    @dams_provenance_collection.personalName.build    
    @dams_provenance_collection.corporateName.build   
    @dams_provenance_collection.conferenceName.build    
    @dams_provenance_collection.familyName.build
   
    @dams_provenance_collection.assembledCollection.build    
   
    @dams_provenance_collection.provenanceCollectionPart.build
    
    @dams_provenance_collection.relationship.build
    @dams_provenance_collection.relationship.first.role.build
    @dams_provenance_collection.relationship.first.personalName.build
    @dams_provenance_collection.relationship.first.name.build
    @dams_provenance_collection.relationship.first.corporateName.build
    @dams_provenance_collection.relationship.first.conferenceName.build
    @dams_provenance_collection.relationship.first.familyName.build

    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    @mads_complex_subjects << "Create New Complex Subject"
    @dams_assembled_collections = get_objects_url('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @dams_personal_names = get_objects_url('MadsPersonalName','name_tesim')
    @dams_corporate_names = get_objects_url('MadsCorporateName','name_tesim')
    @dams_family_names = get_objects_url('MadsFamilyName','name_tesim')
    @dams_conference_names = get_objects_url('MadsConferenceName','name_tesim')
    @dams_provenance_collection_parts=get_objects_url('DamsProvenanceCollectionPart','title_tesim')
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @dams_units = get_objects_url('DamsUnit','unit_name_tesim')
    @dams_related_resources =  get_related_resource_url('DamsRelatedResource','type_tesim','relatedResourceDescription_tesim')
  	@dams_related_resources << "Create New Related Resource"
  end

  def edit
    @dams_provenance_collection = DamsProvenanceCollection.find(params[:id])
    @dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    @mads_complex_subjects << "Create New Complex Subject"
    @dams_units = get_objects('DamsUnit','unit_name_tesim')   
    @dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    @dams_names = get_objects('MadsPersonalName','name_tesim')
	@dams_related_resources =  get_related_resource_url('DamsRelatedResource','type_tesim','relatedResourceDescription_tesim')
  	@dams_related_resources << "Create New Related Resource"
  	    
    #@provenance_collection_part_id = @dams_provenance_collection.part_node.to_s.gsub(/.*\//,'')[0..9]
    @provenance_collection_part_id = @dams_provenance_collection.provenanceCollectionPart.to_s.gsub(/.*\//,'')[0..9]
    @language_id = @dams_provenance_collection.language.to_s.gsub(/.*\//,'')[0..9]
	@unit_id = @dams_provenance_collection.unit.to_s.gsub(/.*\//,'')[0..9]
	
    @simple_subject_type = get_simple_subject_type(@dams_provenance_collection)  
    @dams_simple_subjects = get_objects(@simple_subject_type,'name_tesim')
    @simpleSubject_id = get_simple_subject_id(@dams_provenance_collection)
    @complexSubject_id = @dams_provenance_collection.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_provenance_collection.complexSubject.nil?
    @simpleSubjectValue = get_simple_subject_value(@dams_provenance_collection)


    @simple_name_type = get_name_type(@dams_provenance_collection)
    @simple_name_id = get_name_id(@dams_provenance_collection)   
    @simple_names = get_objects("Mads#{@simple_name_type}",'name_tesim')  
    @simple_name_value = get_name_value(@dams_provenance_collection)
	@simpleSubjects = get_simple_subjects(@dams_provenance_collection) 
    @creators = get_creators(@dams_provenance_collection)
	@relationships = get_relationships(@dams_provenance_collection)      
  
  end

  def create

    # Handling autocompleted field for data returned from remote website (LOC, etc.)
    # create Mads/Dams records and push uri to obj param list.

    @dams_provenance_collection = DamsProvenanceCollection.new
       if !params["dams_provenance_collection"].empty?
         hash_of_param = params["dams_provenance_collection"]
          
          hash_of_param.each do |k, v|

           arr_of_sub = 
           ["builtWorkPlace_attributes", "culturalContext_attributes", "function_attributes", 
            "genreForm_attributes", "geographic_attributes", "iconography_attributes", "occupation_attributes", 
            "scientificName_attributes", "stylePeriod_attributes", "technique_attributes", "temporal_attributes", 
            "topic_attributes"]

            arr_of_name = 
            ["conferenceName_attributes", "corporateName_attributes", "personalName_attributes",
            "familyName_attributes", "name_attributes"]
           
           if arr_of_sub.include?(k) || arr_of_name.include?(k)             
              
              sub_type = k[0, k.index('_')]
              sub_type = sub_type[0, 1].capitalize + sub_type[1..-1]
              hash_of_value = v
              
              hash_of_value.each do |key, sub|
                
               if sub["id"]!= nil
                  if /loc:/.match(sub["id"])
                    #name = value[value.index('_')+7, value.length-1]
                    name = sub["label"]
                    do_mapping(sub_type, name, arr_of_sub, arr_of_name, k, sub)
                  end
               elsif sub["id"]== nil && sub["label"]!= nil
                name = sub["label"]
                do_mapping(sub_type, name, arr_of_sub, arr_of_name, k, sub) 
               end
             end
           end
         end
      end

      @dams_provenance_collection.attributes = params[:dams_provenance_collection] 

    if @dams_provenance_collection.save
      @dams_provenance_collection.reload
      begin
          @dams_provenance_collection.send :update_index
      rescue Exception => e
          logger.warn "Error reindexing #{@dams_provenance_collection.pid}: #{e}"
      end        
    #index_links(@dams_provenance_collection)
      redirect_to @dams_provenance_collection, notice: "Object has been saved"
      #redirect_to edit_dams_provenance_collection_path(@dams_provenance_collection), notice: "Object has been saved"
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
  end



  def update
    @dams_provenance_collection.title.clear
    @dams_provenance_collection.date.clear
    @dams_provenance_collection.language.clear
    @dams_provenance_collection.note.clear
    @dams_provenance_collection.scopeContentNote.clear
    @dams_provenance_collection.custodialResponsibilityNote.clear
    @dams_provenance_collection.preferredCitationNote.clear
    @dams_provenance_collection.relatedResource.clear
    @dams_provenance_collection.complexSubject.clear
    @dams_provenance_collection.builtWorkPlace.clear
    @dams_provenance_collection.culturalContext.clear
    @dams_provenance_collection.function.clear    
    @dams_provenance_collection.genreForm.clear
    @dams_provenance_collection.geographic.clear
    @dams_provenance_collection.iconography.clear    
    @dams_provenance_collection.occupation.clear
    @dams_provenance_collection.scientificName.clear
    @dams_provenance_collection.stylePeriod.clear    
    @dams_provenance_collection.technique.clear   
    @dams_provenance_collection.topic.clear
    @dams_provenance_collection.temporal.clear
    @dams_provenance_collection.name.clear
    @dams_provenance_collection.personalName.clear    
    @dams_provenance_collection.corporateName.clear   
    @dams_provenance_collection.conferenceName.clear    
    @dams_provenance_collection.familyName.clear  
    @dams_provenance_collection.assembledCollection.clear     
    @dams_provenance_collection.provenanceCollectionPart.clear
    @dams_provenance_collection.relationship.clear    
    @dams_provenance_collection.unit.clear

    # Handling autocompleted field for data coming from remote website such as LOC, and mapping to Mads/Dams classes.
       @dams_provenance_collection = DamsProvenanceCollection.new
       hash_of_param = nil
       type_of_field = nil

       if params["dams_provenance_collection"]["simpleSubjectURI"]!= nil && (!params["dams_provenance_collection"]["simpleSubjectURI"].empty?)
          hash_of_param = params["dams_provenance_collection"]["simpleSubjectURI"]
          type_of_field = "subject"
       elsif params["dams_provenance_collection"]["creatorURI"]!= nil && (!params["dams_provenance_collection"]["creatorURI"].empty?)
          hash_of_param = params["dams_provenance_collection"]["creatorURI"]
          type_of_field = "creator"
       end

       if hash_of_param != nil  
         hash_of_param.each_with_index do |value, index|
           
           # Getting data from external resouce and mapping to Mads or Dams class
           if /loc:/.match(value)
 
              sub_type = nil
              
              sub_type = value[4, value.index('_') - 4]
              sub_type = "Topic" if sub_type == nil

              name = value[value.index('_')+7, value.length-1]
              element_value = name
              scheme_id = "http://library.ucsd.edu/ark:/20775/bd9386739x"
              element_attributes = sub_type[0, 1].downcase + sub_type[1..-1] +"Element_attributes"

              if type_of_field == "subject"
                sub_hash = {
                "name" => name, 
                 element_attributes =>
                 {"0" => {"elementValue" => element_value }},
                 "scheme_attributes"=>{"0" => {"id" => scheme_id}}
               }
              elsif type_of_field == "creator"
                sub_hash = {
                         "name" => name, 
                         "scheme_attributes"=>{"0" => {"id" => scheme_id}}
                         }
              end
             
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

        if hash_of_param != nil && type_of_field != nil
          if type_of_field == "subject"
             arr_of_type = params["dams_provenance_collection"]["subjectType"]
             arr_of_type.each_with_index do |v, i|
               arr_of_type[i] = "Topic" if v == ""
             end
          elsif type_of_field == "creator"
             arr_of_type = params["dams_provenance_collection"]["nameType"]
             arr_of_type.each_with_index do |v, i|
               arr_of_type[i] = "name" if v == ""
             end
          end 
        end

    @dams_provenance_collection.attributes = params[:dams_provenance_collection]
    if @dams_provenance_collection.save
        redirect_to @dams_provenance_collection, notice: "Successfully updated provenance_collection"
    else
      flash[:alert] = "Unable to save provenance_collection"
      render :edit
    end
  end

  def data_view
      data = get_html_data ( params[:id] )
      render :text => data
  end 

  def do_mapping(sub_type, name, arr_of_sub, arr_of_name, k, sub)
      element_value = name
      scheme_id = "http://library.ucsd.edu/ark:/20775/bd9386739x"
      element_attributes = sub_type[0, 1].downcase + sub_type[1..-1] +"Element_attributes"
      
      if arr_of_sub.include?(k)
        sub_hash = {
         "name" => name, 
         element_attributes =>
         {"0" => {"elementValue" => element_value }},
         "scheme_attributes"=>{"0" => {"id" => scheme_id}}
        }
      elsif arr_of_name.include?(k)
        sub_hash = {
         "name" => name, 
         "scheme_attributes"=>{"0" => {"id" => scheme_id}}
        }
      end
     class_name = get_class_name(sub_type)
     class_ref = class_name.constantize
     obj = class_ref.new
     obj.attributes = sub_hash
     obj.save
     # add the uri to obje parameter list
     uri = "#{Rails.configuration.id_namespace}#{obj.pid}"
     sub["id"]= uri
  end

  def get_class_name(name)
    arr_of_dams = ["BuiltWorkPlace", "CulturalContext", "Function", "Iconography", "StylePeriod", "Technique", "ScientificName" ]
  
    if arr_of_dams.include?(name)
      class_name = "Dams" + name
    else
      class_name = "Mads" + name 
    end
  end

  def index
     @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsProvenanceCollection"', :rows => 100 )
   end
end
