class DamsLicensesController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_license = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsLicense"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_license = DamsLicense.find(params[:id])   
  end
  
  def new
    @dams_license.restriction_node.build
    @dams_license.permission_node.build
  end

  def edit
  end

  def create
    if @dams_license.save
        redirect_to @dams_license, notice: "License has been saved"
    else
      flash[:alert] = "Unable to save License"
      render :new
    end
  end

  def update
    @dams_license.restriction_node.clear
    @dams_license.permission_node.clear 
    @dams_license.attributes = params[:dams_license]
    if @dams_license.save
        redirect_to @dams_license, notice: "Successfully updated License"
    else
      flash[:alert] = "Unable to save License"
      render :edit
    end
  end

end
