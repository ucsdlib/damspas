class DamsStatutesController < ApplicationController
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
    @current_statute = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsStatute"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_statute = DamsStatute.find(params[:id])   
  end
  
  def new
    @dams_statute.restriction_node.build
    @dams_statute.permission_node.build
  end

  def edit
  end


  def create
    if @dams_statute.save
        redirect_to @dams_statute, notice: "Statute has been saved"
    else
      flash[:alert] = "Unable to save Statute"
      render :new
    end
  end

  def update
    @dams_statute.restriction_node.clear
    @dams_statute.permission_node.clear  
    @dams_statute.attributes = params[:dams_statute]
    if @dams_statute.save
        redirect_to @dams_statute, notice: "Successfully updated Statute"
    else
      flash[:alert] = "Unable to save Statute"
      render :edit
    end
  end

end
