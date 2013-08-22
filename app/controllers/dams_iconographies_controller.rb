class DamsIconographiesController < ApplicationController
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
    @current_iconography = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_iconographys = DamsIconography.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsIconography"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_iconography = DamsIconography.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @dams_iconography = DamsIconography.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    if(@dams_iconography.scheme != nil)
    	@scheme_id = @dams_iconography.scheme.to_s.gsub /.*\//, ""
    	#@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end   
  end

  def create
    @dams_iconography.attributes = params[:dams_iconography]
    if @dams_iconography.save
        redirect_to @dams_iconography, notice: "iconography has been saved"
    else
      flash[:alert] = "Unable to save iconography"
      render :new
    end
  end

  def update
    @dams_iconography.attributes = params[:dams_iconography]
    if @dams_iconography.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated iconography"
        else      
        	redirect_to @dams_iconography, notice: "Successfully updated iconography"
        end
    else
      flash[:alert] = "Unable to save iconography"
      render :edit
    end
  end

end
