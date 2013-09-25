class DamsBuiltWorkPlacesController < ApplicationController
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
    @current_built_work_place = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_built_work_places = DamsBuiltWorkPlace.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsBuiltWorkPlace"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_built_work_place = DamsBuiltWorkPlace.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @dams_built_work_place.scheme.build
    @dams_built_work_place.elementList.builtWorkPlaceElement.build
  @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_built_work_place.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_built_work_place.save
        redirect_to @dams_built_work_place, notice: "built work place has been saved"
    else
      flash[:alert] = "Unable to save built work place"
      render :new
    end
  end

  def update
    @dams_built_work_place.elementList.clear
    @dams_built_work_place.scheme.clear  
    @dams_built_work_place.attributes = params[:dams_built_work_place]
    if @dams_built_work_place.save
    if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
          redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated built work place"
        else      
          redirect_to @dams_built_work_place, notice: "Successfully updated built work place"
        end
    else
      flash[:alert] = "Unable to save built work place"
      render :edit
    end
  end

end