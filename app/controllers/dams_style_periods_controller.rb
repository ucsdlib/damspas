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
    @dams_style_period.scheme.build
    @dams_style_period.elementList.stylePeriodElement.build
  @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_style_period.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_style_period.save
        redirect_to @dams_style_period, notice: "style period has been saved"
    else
      flash[:alert] = "Unable to save style period"
      render :new
    end
  end

  def update
    @dams_style_period.elementList.clear
    @dams_style_period.scheme.clear  
    @dams_style_period.attributes = params[:dams_style_period]
    if @dams_style_period.save
    if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
          redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated style period"
        else      
          redirect_to @dams_style_period, notice: "Successfully updated style period"
        end
    else
      flash[:alert] = "Unable to save style period"
      render :edit
    end
  end

end