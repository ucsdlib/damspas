class MadsPersonalNamesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_personal_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_personal_names = MadsPersonalName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsPersonalName" AND NOT name_tesim:"Personal Name Test" AND NOT name_tesim:"Personal Name" AND NOT name_tesim:"Test Name"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_personal_name = MadsPersonalName.find(params[:id])
  end

  def new

  end

  def edit
    #@mads_personal_name = MadsPersonalName.find(params[:id])
  end

  def create
    @mads_personal_name.attributes = params[:mads_personal_name]
    if @mads_personal_name.save
        redirect_to @mads_personal_name, notice: "personal_name has been saved"
    else
      flash[:alert] = "Unable to save personal_name"
      render :new
    end
  end

  def update
    @mads_personal_name.attributes = params[:mads_personal_name]
    if @mads_personal_name.save
        redirect_to @mads_personal_name, notice: "Successfully updated personal_name"
    else
      flash[:alert] = "Unable to save personal_name"
      render :edit
    end
  end

end
