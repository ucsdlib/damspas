require 'net/http'
require 'json'

class DamsProvenanceCollectionPartsController < ApplicationController
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
    
    @dams_provenance_collection_part.title.build
    @dams_provenance_collection_part.title.first.elementList.subTitleElement.build
    @dams_provenance_collection_part.title.first.hasVariant.build
    @dams_provenance_collection_part.title.first.hasTranslationVariant.build
    @dams_provenance_collection_part.title.first.hasAbbreviationVariant.build
    @dams_provenance_collection_part.title.first.hasAcronymVariant.build
    @dams_provenance_collection_part.title.first.hasExpansionVariant.build
    @dams_provenance_collection_part.date.build
    @dams_provenance_collection_part.language.build
    
    @dams_provenance_collection_part.note.build
    @dams_provenance_collection_part.scopeContentNote.build
    @dams_provenance_collection_part.custodialResponsibilityNote.build
    @dams_provenance_collection_part.preferredCitationNote.build
    @dams_provenance_collection_part.relatedResource.build
    
    @dams_provenance_collection_part.complexSubject.build
    @dams_provenance_collection_part.builtWorkPlace.build
    @dams_provenance_collection_part.culturalContext.build
    @dams_provenance_collection_part.function.build    
    @dams_provenance_collection_part.genreForm.build
    @dams_provenance_collection_part.geographic.build
    @dams_provenance_collection_part.iconography.build    
    @dams_provenance_collection_part.occupation.build
    @dams_provenance_collection_part.scientificName.build
    @dams_provenance_collection_part.stylePeriod.build    
    @dams_provenance_collection_part.technique.build   
    @dams_provenance_collection_part.topic.build    
    @dams_provenance_collection_part.temporal.build     
  @dams_provenance_collection_part.name.build
    @dams_provenance_collection_part.personalName.build    
    @dams_provenance_collection_part.corporateName.build   
    @dams_provenance_collection_part.conferenceName.build    
    @dams_provenance_collection_part.familyName.build
   
    @dams_provenance_collection_part.assembledCollection.build    
   
    
    
    @dams_provenance_collection_part.relationship.build
    @dams_provenance_collection_part.relationship.first.role.build
    @dams_provenance_collection_part.relationship.first.personalName.build
    @dams_provenance_collection_part.relationship.first.name.build
    @dams_provenance_collection_part.relationship.first.corporateName.build
    @dams_provenance_collection_part.relationship.first.conferenceName.build
    @dams_provenance_collection_part.relationship.first.familyName.build

    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    @dams_assembled_collections = get_objects_url('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @mads_authorities = get_objects_url('MadsAuthority','name_tesim')
    @dams_personal_names = get_objects_url('MadsPersonalName','name_tesim')
    @dams_corporate_names = get_objects_url('MadsCorporateName','name_tesim')
    @dams_names = get_objects_url('MadsName','name_tesim')
    @dams_family_names = get_objects_url('MadsFamilyName','name_tesim')
    @dams_conference_names = get_objects_url('MadsConferenceName','name_tesim')
   
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    
    
    uri = URI('http://fast.oclc.org/fastSuggest/select')
    res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
    json = JSON.parse(res.body)
    @jdoc = json.fetch("response").fetch("docs")
  
    @autocomplete_items = Array.new
    @jdoc.each do |value|
    @autocomplete_items << value['suggestall']
  end 
  end
  
def edit
    @dams_provenance_collection_part = DamsProvenanceCollectionPart.find(params[:id])
    
    @mads_complex_subjects = get_objects_url('MadsComplexSubject','name_tesim')
    @mads_complex_subjects << "Create New Complex Subject"
    @dams_units = get_objects('DamsUnit','unit_name_tesim')   
    @dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects_url('MadsLanguage','name_tesim')
    @mads_languages << "Create New Language"
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    @dams_names = get_objects('MadsPersonalName','name_tesim')
    
    
    @language_id = @dams_provenance_collection_part.language.to_s.gsub(/.*\//,'')[0..9]
    @role_id = @dams_provenance_collection_part.relationshipRoleURI.to_s.gsub(/.*\//,'')[0..9]
    @name_id = get_relationship_name_id(@dams_provenance_collection_part)
    @name_type = get_relationship_name_type(@dams_provenance_collection_part)
    @dams_names = get_objects("Mads#{@name_type}",'name_tesim')
    @nameTypeArray = Array.new
    @nameTypeArray << @name_type
    @dams_provenance_collection_part.relationshipNameType = @nameTypeArray

    @simple_subject_type = get_simple_subject_type(@dams_provenance_collection_part)  
    @dams_simple_subjects = get_objects(@simple_subject_type,'name_tesim')
    @simpleSubject_id = get_simple_subject_id(@dams_provenance_collection_part)
    @complexSubject_id = @dams_provenance_collection_part.complexSubject.to_s.gsub(/.*\//,'')[0..9] if !@dams_provenance_collection_part.complexSubject.nil?
    @simpleSubjectValue = get_simple_subject_value(@dams_provenance_collection_part)


   @simple_name_type = get_name_type(@dams_provenance_collection_part)
   @simple_name_id = get_name_id(@dams_provenance_collection_part)   
    @simple_names = get_objects("Mads#{@simple_name_type}",'name_tesim')  
    @simple_name_value = get_name_value(@dams_provenance_collection_part)
	@simpleSubjects = get_simple_subjects(@dams_provenance_collection_part)
	
  uri = URI('http://fast.oclc.org/fastSuggest/select')
  res = Net::HTTP.post_form(uri, 'q' => 'suggestall :*', 'fl' => 'suggestall', 'wt' => 'json', 'rows' => '100')
  json = JSON.parse(res.body)
  @jdoc = json.fetch("response").fetch("docs")
  
  @autocomplete_items = Array.new
  @jdoc.each do |value|
    @autocomplete_items << value['suggestall']
  end        
  
  end

  def create
    if @dams_provenance_collection_part.save    
    #index_links(@dams_provenance_collection_part)
      redirect_to @dams_provenance_collection_part, notice: "Object has been saved"
      #redirect_to edit_dams_provenance_collection_part_path(@dams_provenance_collection_part), notice: "Object has been saved"
    else
      flash[:alert] = "Unable to save object"
      render :new
    end
  end

  def update
    @dams_provenance_collection_part.title.clear
    @dams_provenance_collection_part.date.clear
    @dams_provenance_collection_part.language.clear
    @dams_provenance_collection_part.note.clear
    @dams_provenance_collection_part.scopeContentNote.clear
    @dams_provenance_collection_part.custodialResponsibilityNote.clear
    @dams_provenance_collection_part.preferredCitationNote.clear
    @dams_provenance_collection_part.relatedResource.clear
    @dams_provenance_collection_part.complexSubject.clear
    @dams_provenance_collection_part.builtWorkPlace.clear
    @dams_provenance_collection_part.culturalContext.clear
    @dams_provenance_collection_part.function.clear    
    @dams_provenance_collection_part.genreForm.clear
    @dams_provenance_collection_part.geographic.clear
    @dams_provenance_collection_part.iconography.clear    
    @dams_provenance_collection_part.occupation.clear
    @dams_provenance_collection_part.scientificName.clear
    @dams_provenance_collection_part.stylePeriod.clear    
    @dams_provenance_collection_part.technique.clear   
    @dams_provenance_collection_part.topic.clear
    @dams_provenance_collection_part.temporal.clear
    @dams_provenance_collection_part.name.clear
    @dams_provenance_collection_part.personalName.clear    
    @dams_provenance_collection_part.corporateName.clear   
    @dams_provenance_collection_part.conferenceName.clear    
    @dams_provenance_collection_part.familyName.clear
   
    @dams_provenance_collection_part.assembledCollection.clear   
  
    
    


    @dams_provenance_collection_part.attributes = params[:dams_provenance_collection_part]
    if @dams_provenance_collection_part.save
        redirect_to @dams_provenance_collection_part, notice: "Successfully updated provenance_collection_part"
    else
      flash[:alert] = "Unable to save provenance_collection_part"
      render :edit
    end
  end

     def index
     @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsProvenanceCollectionPart"', :rows => 100 )
   end

    
  end
