require 'net/http'
require 'json'
require 'open-uri'

class DamsResourceController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  include CatalogHelper

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    refcon = referrer_controller request
    if params[:counter]
      # if there is a counter, update pager state & redirect to no-counter view
      logger.info "dams_resource_controller#show (#{refcon}) adding query to session and redirecting"
      session[:search][:counter] = params[:counter]
      session[:search_results] = request.referer if refcon == "catalog"
      redirect_to dams_object_path(params[:id])
      return
    else
      @blacklight_config = CatalogController.blacklight_config

      # if we were redirected from counter, setup next/prev
      controllers = ["catalog", "dams_collections", "dams_objects"]
      logger.info "dams_resource_controller#show (#{refcon}) controllers.include?(refcon)? #{controllers.include?(refcon)}"
      setup_next_and_previous_documents if controllers.include?(refcon)
    end

    # get metadata from solr
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    if @document.nil?
        raise ActionController::RoutingError.new('Not Found')
    end

    # generate facet collection list for collection page only
    models = @document["active_fedora_model_ssi"]
    if models.include?("DamsAssembledCollection") || models.include?("DamsProvenanceCollection") || models.include?("DamsProvenanceCollectionPart") 
        facet_collection_params = { :f=>{"collection_sim"=>"#{@document['title_tesim'].first.to_s}"}, :id=>params[:id], :rows => 0 }
        apply_gated_discovery( facet_collection_params, nil )
        @facet_collection_resp = get_search_results( facet_collection_params )
        facet_collection_names = []
        @facet_collections = @facet_collection_resp[0].facet_counts["facet_fields"]["collection_sim"]
        if !@facet_collections.nil? && @facet_collections.length > 0
            @facet_collections.each_slice(2) do |collectionName, *_|
                facet_collection_names << collectionName.strip if !collectionName.strip.eql? @document['title_tesim'].first.strip.to_s
            end
        end
        @related_collections = related_collections_map facet_collection_names
    end

    @rdfxml = @document['rdfxml_ssi']
    if @rdfxml == nil
      @rdfxml = "<rdf:RDF xmlns:dams='http://library.ucsd.edu/ontology/dams#'
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          rdf:about='#{Rails.configuration.id_namespace}#{params[:id]}'>
  <dams:error>content missing</dams:error>
</rdf:RDF>"
    end

    url = check_type @document
    unless url.blank?
      redirect_to url
      return
    end

    # enforce access controls
    if can? :show, @document

      # find related resources
      collectionData = @document["collection_json_tesim"]
	  @collectionDocArray = Array.new
	  if !collectionData.nil? and collectionData.length > 0
	  	collectionData.each do |datum|
          collection = JSON.parse(datum)
		  collectionDoc = get_single_doc_via_search(1, {:q => "id:#{collection['id']}"} )
		  relatedResourceData = collectionDoc["related_resource_json_tesim"] unless collectionDoc.nil?
		  if !relatedResourceData.nil?
			relatedResourceData.each do |datum|
			  relatedResource = JSON.parse(datum)
			  if relatedResource['type'] != "hydra-afmodel"
			    @collectionDocArray << collectionDoc
				break
			  end			
			end
		  end
	    end
	  end

      find_linked_documents @document
	  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
        format.nt { rdf_nt }
        format.ttl { rdf_ttl }
      end
    elsif @document['discover_access_group_ssim'].include?("public")
      respond_to do |format|
        format.html { render :metadata }
        format.json { render json: @document }
        format.rdf { render xml: @rdfxml }
        format.nt { rdf_nt }
        format.ttl { rdf_ttl }
      end
    else
      authorize! :show, @document # 403 forbidden
    end
  end
  def find_linked_documents( document )
  end
  def redirect_other_types( document )
  end
  def dams42
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "dams4.2.xsl"
    data = get_html_data params, nil
    render :xml => data, :content_type => 'application/rdf+xml'
  end 
  def data
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
  	controller_path = dams_collection_path params[:id]
    data = get_html_data params, controller_path
    render :text => data
  end 
  def rdf
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    params[:xsl] = "normalize.xsl"
    data = get_html_data params, nil
    render :xml => data, :content_type => 'application/rdf+xml'
  end
  def rdf_nt
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    data = get_data("nt")
    render :text => data, :content_type => 'application/n-triples'
  end
  def rdf_ttl
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    data = get_data("turtle")
    render :text => data, :content_type => 'text/turtle'
  end 
  def ezid
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :create, @document

    # mint doi
    begin
      json = dams_post "#{dams_api_path}/api/objects/#{params[:id]}/mint_doi?format=json"
      if json['statusCode'] == 200
        logger.info json['message']
        redirect_to dams_object_path(params[:id]), notice: "DOI minted, please allow a few minutes for Solr reindexing before the display is updated."
      else
        redirect_to dams_object_path(params[:id]), alert: "Minting DOI failed: #{json['message']}"
      end
    rescue Exception => e
      begin
        resp = JSON.parse( e.response.body )
        err = resp["message"]
      rescue
        err = "Error minting DOI: Unable to process server response"
      end
      redirect_to dams_object_path(params[:id]), alert: err
    end
  end

  def related_collections_map (collection_names)
    colls_map = {}
    if collection_names.count > 0
        collection_names.collect! { |name| "\"#{solr_escape(name)}\"" }
        solr_param_q = collection_names.join (' OR ')
        solr_params = { :q => "type_tesim:Collection AND title_tesim:(#{solr_param_q})", :rows => collection_names.count }
        cols_response, col_documents = get_search_results(solr_params)
        cols_response.docs.each do |doc|
            colls_map[doc['title_tesim'].first.to_s.strip] = doc['id_t'].to_s
        end
    end
    colls_map
  end

  def solr_escape (str)
    pattern = /(\+|\-|\&\&|\|\||\!|\(\)|\{\}|\[|\]|\^|\"|\~|\*|\?|\:|\\)/
    str.gsub(pattern){|match|"\\"  + match} 
  end

  def osf_api
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    data = export_to_API(@document)
    render :json => data
  end

  def osf_push
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
    authorize! :show, @document
    document = ShareNotify::PushDocument.new("http://library.ucsd.edu/dc/collection/#{params[:id]}", osf_date(@document))
    document.title = osf_title(@document)
    document.description = osf_description(@document)
    document.publisher = osf_publisher
    document.languages = osf_languages(@document)
    document.tags = osf_mads_fields(@document)
    osf_contributors(@document).each do |contributor|
      document.add_contributor(contributor)
    end

    if document.valid?
      api = ShareNotify::API.new
      api.post(document.to_share.to_json)
      redirect_to dams_collection_path(params[:id]), notice: "Your record has been pushed to OSF Share Staging area."
    else
      redirect_to dams_collection_path(params[:id]), alert: "Your record is not valid."
    end
  end

end
