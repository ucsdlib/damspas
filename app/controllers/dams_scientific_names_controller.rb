class DamsScientificNamesController < ApplicationController
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
    @current_scientific_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_scientific_names = DamsScientificName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsScientificName"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_scientific_name = DamsScientificName.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @dams_scientific_name.scheme.build
    @dams_scientific_name.elementList.scientificNameElement.build
  @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_scientific_name.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_scientific_name.save
        redirect_to @dams_scientific_name, notice: "scientific name has been saved"
    else
      flash[:alert] = "Unable to save scientific name"
      render :new
    end
  end

  def update
    @dams_scientific_name.elementList.clear
    @dams_scientific_name.scheme.clear  
    @dams_scientific_name.attributes = params[:dams_scientific_name]
    if @dams_scientific_name.save
    if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
          redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated scientific name"
        else      
          redirect_to @dams_scientific_name, notice: "Successfully updated scientific name"
        end
    else
      flash[:alert] = "Unable to save scientific name"
      render :edit
    end
  end

end