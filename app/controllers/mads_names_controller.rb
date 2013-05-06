class MadsNamesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_names = MadsName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsName" AND NOT name_tesim:"Name Test" AND NOT name_tesim:"Test Name"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_name = MadsName.find(params[:id])
  end

  def new

  end

  def edit
    #@mads_name = MadsName.find(params[:id])
  end

  def create
    @mads_name.attributes = params[:mads_name]
    if @mads_name.save
        redirect_to @mads_name, notice: "name has been saved"
    else
      flash[:alert] = "Unable to save name"
      render :new
    end
  end

  def update
    @mads_name.attributes = params[:mads_name]
    if @mads_name.save
        redirect_to @mads_name, notice: "Successfully updated name"
    else
      flash[:alert] = "Unable to save name"
      render :edit
    end
  end

end
