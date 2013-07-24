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
    #Check schemes ####################################################################
    @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @dams_function = DamsFunction.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    if(@dams_function.scheme != nil)
    	@scheme_id = @dams_function.scheme.to_s.gsub /.*\//, ""
    	#@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end   
  end

  def create
    @dams_function.attributes = params[:dams_function]
    if @dams_function.save
        redirect_to @dams_function, notice: "function has been saved"
    else
      flash[:alert] = "Unable to save function"
      render :new
    end
  end

  def update
    @dams_function.attributes = params[:dams_function]
    if @dams_function.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated function"
        else      
        	redirect_to @dams_function, notice: "Successfully updated function"
        end
    else
      flash[:alert] = "Unable to save function"
      render :edit
    end
  end

end
