class DamsCopyrightsController < ApplicationController
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
    @current_copyright = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_copyrights = DamsCopyright.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsCopyright"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_copyright = DamsCopyright.find(params[:id])   
  end
  
  def new
    @dams_copyright.date.build
  end

  def edit
  end

  def create
    if @dams_copyright.save
        redirect_to @dams_copyright, notice: "Copyright has been saved"
    else
      flash[:alert] = "Unable to save Copyright"
      render :new
    end
  end

  def update
    @dams_copyright.date.clear

    @dams_copyright.attributes = params[:dams_copyright]
    if @dams_copyright.save
        redirect_to @dams_copyright, notice: "Successfully updated Copyright"        
    else
      flash[:alert] = "Unable to save Copyright"
      render :edit
    end
  end

end

