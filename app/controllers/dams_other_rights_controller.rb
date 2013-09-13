class DamsOtherRightsController < ApplicationController
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
    @current_other_right = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsOtherRight"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_other_right = DamsOtherRight.find(params[:id])
   
  end

  def edit
    @dams_other_right = DamsOtherRight.find(params[:id])
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    @mads_names = get_objects('MadsName','name_tesim')
    @name_id = @dams_other_right.name.to_s.gsub(/.*\//,'')[0..9]
    @role_id = @dams_other_right.role.to_s.gsub(/.*\//,'')[0..9]  
  end
  
  def new
    @dams_other_right.restriction_node.build
    @dams_other_right.permission_node.build
    @mads_authorities = get_objects('MadsAuthority','name_tesim')
    @mads_names = get_objects('MadsName','name_tesim')
  end

  def create
    if @dams_other_right.save
        redirect_to @dams_other_right, notice: "OtherRights has been saved"
    else
      flash[:alert] = "Unable to save OtherRights"
      render :new
    end
  end

  def update
    @dams_other_right.restriction_node.clear
    @dams_other_right.permission_node.clear 
    @dams_other_right.attributes = params[:dams_other_right]
    if @dams_other_right.save
        redirect_to @dams_other_right, notice: "Successfully updated OtherRights"
    else
      flash[:alert] = "Unable to save OtherRights"
      render :edit
    end
  end
end
