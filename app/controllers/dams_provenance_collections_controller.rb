require 'net/http'
require 'json'

class DamsProvenanceCollectionsController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
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

  def show
    @dams_provenance_collection = DamsProvenanceCollection.find(params[:id])
    #@dams_objects = DamsObject.find(params[:id])
    #@dams_languages = MadsLanguage.find(params[:id])
    
  end

  def new
    
    @mads_names = MadsPersonalName.all( :order=>"system_create_dtsi asc" )
    @dams_provenance_collection_parts=DamsProvenanceCollectionPart.all( :order=>"system_create_dtsi asc" )
    
    @mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
    @dams_units = get_objects('DamsUnit','unit_name_tesim')   
    @dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects('MadsLanguage','name_tesim')
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    

  end

  def edit
    @mads_complex_subjects = get_objects('MadsComplexSubject','name_tesim')
    @dams_units = get_objects('DamsUnit','unit_name_tesim')   
    @dams_assembled_collections = get_objects('DamsAssembledCollection','title_tesim')
    @mads_languages =  get_objects('MadsLanguage','name_tesim')
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    
    @dams_provenance_collection_parts=DamsProvenanceCollectionPart.all( :order=>"system_create_dtsi asc" )
  
    @language_id = @dams_object.language.to_s.gsub(/.*\//,'')[0..9]
    @name_id = @dams_object.relationshipNameURI.to_s.gsub(/.*\//,'')[0..9]

  end

  def create
    @dams_provenance_collection.attributes = params[:dams_provenance_collection]
    if @dams_provenance_collection.save
        redirect_to @dams_provenance_collection, notice: "ProvenanceCollection has been saved"
    else
      flash[:alert] = "Unable to save provenance_collection"
      render :new
    end
  end

  def update
    @dams_provenance_collection.attributes = params[:dams_provenance_collection]
    if @dams_provenance_collection.save
        redirect_to @dams_provenance_collection, notice: "Successfully updated provenance_collection"
    else
      flash[:alert] = "Unable to save provenance_collection"
      render :edit
    end
  end

  def index
    @units = DamsProvenanceCollection.all( :order=>"system_create_dtsi asc" )
  end


end
