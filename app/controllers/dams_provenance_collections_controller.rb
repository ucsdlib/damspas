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
    @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
    @dams_units = DamsUnit.all( :order=>"system_create_dtsi asc" )
    @dams_assembled_collections = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
    @dams_objects = DamsObject.all( :order=>"system_create_dtsi asc" )
    @mads_languages = MadsLanguage.all( :order=>"system_create_dtsi asc" )
    @mads_authorities = MadsAuthority.all( :order=>"system_create_dtsi asc" )
    @mads_names = MadsPersonalName.all( :order=>"system_create_dtsi asc" )
    @dams_provenance_collection_parts=DamsProvenanceCollectionPart.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @dams_provenance_collection = DamsProvenanceCollection.find(params[:id])
    @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
    @dams_units = DamsUnit.all( :order=>"system_create_dtsi asc" )
    @dams_assembled_collections = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
    @dams_objects = DamsObject.all( :order=>"system_create_dtsi asc" )
    @mads_languages = MadsLanguage.all( :order=>"system_create_dtsi asc" )
    @mads_authorities = MadsAuthority.all( :order=>"system_create_dtsi asc" )
    @mads_names = MadsPersonalName.all( :order=>"system_create_dtsi asc" )
    @dams_provenance_collection_parts=DamsProvenanceCollectionPart.all( :order=>"system_create_dtsi asc" )
    #@dams_provenance_collection_parts=DamsProvenanceCollectionPart.find(params[:id])
    
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
