require 'net/http'
require 'json'

class DamsAssembledCollectionsController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only => :index

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

  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsAssembledCollection"', :rows => 100 )
  end

  def data_view
  	  controller_path = dams_collection_path params[:id]
      data = get_html_data params, controller_path
      render :text => data
  end
end
