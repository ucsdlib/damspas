require 'net/http'
require 'json'

class DamsAssembledCollectionsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    
     # check ip for unauthenticated users
    if current_user == nil
      current_user = User.anonymous(request.ip)
    end

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
     @dams_assembled_collection.title.build
    @dams_assembled_collection.title.first.elementList.subTitleElement.build
    @dams_assembled_collection.title.first.hasVariant.build
    @dams_assembled_collection.title.first.hasTranslationVariant.build
    @dams_assembled_collection.title.first.hasAbbreviationVariant.build
    @dams_assembled_collection.title.first.hasAcronymVariant.build
    @dams_assembled_collection.title.first.hasExpansionVariant.build
    @dams_assembled_collection.date.build
    @dams_assembled_collection.language.build
    
    @dams_assembled_collection.note.build
    @dams_assembled_collection.scopeContentNote.build
    @dams_assembled_collection.custodialResponsibilityNote.build
    @dams_assembled_collection.preferredCitationNote.build
    @dams_assembled_collection.relatedResource.build
    
    @dams_assembled_collection.complexSubject.build
    @dams_assembled_collection.builtWorkPlace.build
    @dams_assembled_collection.culturalContext.build
    @dams_assembled_collection.function.build    
    @dams_assembled_collection.genreForm.build
    @dams_assembled_collection.geographic.build
    @dams_assembled_collection.iconography.build    
    @dams_assembled_collection.occupation.build
    @dams_assembled_collection.scientificName.build
    @dams_assembled_collection.stylePeriod.build    
    @dams_assembled_collection.technique.build   
    @dams_assembled_collection.topic.build    
    @dams_assembled_collection.temporal.build     
    @dams_assembled_collection.name.build
    @dams_assembled_collection.personalName.build    
    @dams_assembled_collection.corporateName.build   
    @dams_assembled_collection.conferenceName.build    
    @dams_assembled_collection.familyName.build
   
    
   
    @dams_assembled_collection.provenanceCollectionPart.build
    
    @dams_assembled_collection.relationship.build
    @dams_assembled_collection.relationship.first.role.build
    @dams_assembled_collection.relationship.first.personalName.build
    @dams_assembled_collection.relationship.first.name.build
    @dams_assembled_collection.relationship.first.corporateName.build
    @dams_assembled_collection.relationship.first.conferenceName.build
    @dams_assembled_collection.relationship.first.familyName.build

    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @mads_authorities = get_objects_url('MadsAuthority','name_tesim')
    @dams_personal_names = get_objects_url('MadsPersonalName','name_tesim')
    @dams_corporate_names = get_objects_url('MadsCorporateName','name_tesim')
    @dams_names = get_objects_url('MadsName','name_tesim')
    @dams_family_names = get_objects_url('MadsFamilyName','name_tesim')
    @dams_conference_names = get_objects_url('MadsConferenceName','name_tesim')
    @dams_provenance_collection_parts=get_objects_url('DamsProvenanceCollectionPart','title_tesim')
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    
    
  #   uri = URI('http://fast.oclc.org/fastSuggest/select')
  #   res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
  #   json = JSON.parse(res.body)
  #   @jdoc = json.fetch("response").fetch("docs")
  
  #   @autocomplete_items = Array.new
  #   @jdoc.each do |value|
  #   @autocomplete_items << value['suggestall']
  # end

end

  def edit
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
    @dams_provenance_collection_parts=get_objects('DamsProvenanceCollectionPart','title_tesim')
    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    @mads_complex_subjects << "Create New Complex Subject"
    @dams_units = get_objects('DamsUnit','unit_name_tesim')   
  
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    @dams_names = get_objects('MadsPersonalName','name_tesim')
    
    #@provenance_collection_part_id = @dams_assembled_collection.part_node.to_s.gsub(/.*\//,'')[0..9]
    @provenance_collection_part_id = @dams_assembled_collection.provenanceCollectionPart.to_s.gsub(/.*\//,'')[0..9]
    @language_id = @dams_assembled_collection.language.to_s.gsub(/.*\//,'')[0..9]
    @role_id = @dams_assembled_collection.relationshipRoleURI.to_s.gsub(/.*\//,'')[0..9]
    @name_id = get_relationship_name_id(@dams_assembled_collection)
    @name_type = get_relationship_name_type(@dams_assembled_collection)
    @dams_names = get_objects("Mads#{@name_type}",'name_tesim')
    @nameTypeArray = Array.new
    @nameTypeArray << @name_type
    @dams_assembled_collection.relationshipNameType = @nameTypeArray

    @simple_subject_type = get_simple_subject_type(@dams_assembled_collection)  
    @dams_simple_subjects = get_objects(@simple_subject_type,'name_tesim')
    @simpleSubject_id = get_simple_subject_id(@dams_assembled_collection)
    # @creator_id = get_creator_id(@dams_assembled_collection)
    @creator_id = get_name_id(@dams_assembled_collection)   
    @complexSubject_id = @dams_assembled_collection.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_assembled_collection.complexSubject.nil?
    @simpleSubjectValue = get_simple_subject_value(@dams_assembled_collection)


   @simple_name_type = get_name_type(@dams_assembled_collection)
   @creator_type = get_name_type(@dams_assembled_collection)

   # @simple_name_id = get_name_id(@dams_assembled_collection)   
    @simple_names = get_objects("Mads#{@simple_name_type}",'name_tesim')  
    @simple_name_value = get_name_value(@dams_assembled_collection)
    @creators = get_creators(@dams_assembled_collection)
	@simpleSubjects = get_simple_subjects(@dams_assembled_collection)

  # uri = URI('http://fast.oclc.org/fastSuggest/select')
  # res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
  # json = JSON.parse(res.body)
  # @jdoc = json.fetch("response").fetch("docs")
  
  # @autocomplete_items = Array.new
  # @jdoc.each do |value|
  #   @autocomplete_items << value['suggestall']
  # end

end

  def create
    if @dams_assembled_collection.save    
      #index_links(@dams_assembled_collection)
      if(!params[:parent_id].nil?)
        redirect_to view_dams_assembled_collection_path(@dams_assembled_collection, {:parent_id => params[:parent_id]})
      elsif(!params[:parent_class].nil?)
        redirect_to view_dams_assembled_collection_path(@dams_assembled_collection, {:parent_class => params[:parent_class]})
      else
        #redirect_to edit_dams_assembled_collection_path(@dams_assembled_collection), notice: "Object has been saved"
        redirect_to @dams_assembled_collection, notice: "Object has been saved"
      end
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
  end

  def update
    @dams_assembled_collection.title.clear
    @dams_assembled_collection.date.clear
    @dams_assembled_collection.language.clear
    @dams_assembled_collection.note.clear
    @dams_assembled_collection.scopeContentNote.clear
    @dams_assembled_collection.custodialResponsibilityNote.clear
    @dams_assembled_collection.preferredCitationNote.clear
    @dams_assembled_collection.relatedResource.clear
    @dams_assembled_collection.complexSubject.clear
    @dams_assembled_collection.builtWorkPlace.clear
    @dams_assembled_collection.culturalContext.clear
    @dams_assembled_collection.function.clear    
    @dams_assembled_collection.genreForm.clear
    @dams_assembled_collection.geographic.clear
    @dams_assembled_collection.iconography.clear    
    @dams_assembled_collection.occupation.clear
    @dams_assembled_collection.scientificName.clear
    @dams_assembled_collection.stylePeriod.clear    
    @dams_assembled_collection.technique.clear   
    @dams_assembled_collection.topic.clear
    @dams_assembled_collection.temporal.clear
    @dams_assembled_collection.name.clear
    @dams_assembled_collection.personalName.clear    
    @dams_assembled_collection.corporateName.clear   
    @dams_assembled_collection.conferenceName.clear    
    @dams_assembled_collection.familyName.clear
   
    
  
    @dams_assembled_collection.provenanceCollectionPart.clear
    


    @dams_assembled_collection.attributes = params[:dams_assembled_collection]
    if @dams_assembled_collection.save
        redirect_to @dams_assembled_collection, notice: "Successfully updated assembled_collection"
    else
      flash[:alert] = "Unable to save assembled_collection"
      render :edit
    end
  end

  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsAssembledCollection"', :rows => 100 )
  end


end
