class DamsFunctionsController < ApplicationController
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
    @current_function = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_functions = DamsFunction.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsFunction"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_function = DamsFunction.find(params[:id])
  end

  def new
    @dams_function.scheme.build
    @dams_function.elementList.functionElement.build
    #Check schemes ####################################################################
    @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_function.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_function.save
        redirect_to @dams_function, notice: "function has been saved"
    else
      flash[:alert] = "Unable to save function"
      render :new
    end
  end

  def update
    @dams_function.elementList.clear
    @dams_function.scheme.clear
    @dams_function.attributes = params[:dams_function]
    if @dams_function.save
      redirect_to @dams_function, notice: "Successfully updated function"
    else
      flash[:alert] = "Unable to save function"
      render :edit
    end
  end

end
