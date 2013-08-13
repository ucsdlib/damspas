require 'net/http'
require 'json'

class DamsAssembledCollectionsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
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

  end

  def edit

  end

  def create
    @dams_assembled_collection.attributes = params[:dams_assembled_collection]
    if @dams_assembled_collection.save
        redirect_to @dams_assembled_collection, notice: "AssembledCollection has been saved"
    else
      flash[:alert] = "Unable to save assembled_collection"
      render :new
    end
  end

  def update
    @dams_assembled_collection.attributes = params[:dams_assembled_collection]
    if @dams_assembled_collection.save
        redirect_to @dams_assembled_collection, notice: "Successfully updated assembled_collection"
    else
      flash[:alert] = "Unable to save assembled_collection"
      render :edit
    end
  end

  def index
    @units = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
  end


end
