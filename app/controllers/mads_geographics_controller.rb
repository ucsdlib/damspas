class MadsGeographicsController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_geographic = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_geographics = MadsGeographic.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsGeographic"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_geographic = MadsGeographic.find(params[:id])
  end

  def new

  end

  def edit
    #@mads_geographic = MadsGeographic.find(params[:id])
  end

  def create
    @mads_geographic.attributes = params[:mads_geographic]
    if @mads_geographic.save
        redirect_to @mads_geographic, notice: "geographic has been saved"
    else
      flash[:alert] = "Unable to save geographic"
      render :new
    end
  end

  def update
    @mads_geographic.attributes = params[:mads_geographic]
    if @mads_geographic.save
        redirect_to @mads_geographic, notice: "Successfully updated geographic"
    else
      flash[:alert] = "Unable to save geographic"
      render :edit
    end
  end

end
