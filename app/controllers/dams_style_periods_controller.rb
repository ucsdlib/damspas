class DamsStylePeriodsController < ApplicationController
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
    @current_style_period = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_style_periods = DamsStylePeriod.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsStylePeriod"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_style_period = DamsStylePeriod.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @dams_style_period = DamsStylePeriod.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    if(@dams_style_period.scheme != nil)
    	@scheme_id = @dams_style_period.scheme.to_s.gsub /.*\//, ""
    	#@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end   
  end

  def create
    @dams_style_period.attributes = params[:dams_style_period]
    if @dams_style_period.save
        redirect_to @dams_style_period, notice: "style_period has been saved"
    else
      flash[:alert] = "Unable to save style_period"
      render :new
    end
  end

  def update
    @dams_style_period.attributes = params[:dams_style_period]
    if @dams_style_period.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated style_period"
        else      
        	redirect_to @dams_style_period, notice: "Successfully updated style_period"
        end
    else
      flash[:alert] = "Unable to save style_period"
      render :edit
    end
  end

end
