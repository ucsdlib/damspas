class DamsTechniquesController < ApplicationController
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
    @current_technique = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_techniques = DamsTechnique.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsTechnique"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_technique = DamsTechnique.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @dams_technique.scheme.build
    @dams_technique.elementList.techniqueElement.build
    @mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_technique.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    
    if @dams_technique.save
        redirect_to @dams_technique, notice: "technique has been saved"
    else
      flash[:alert] = "Unable to save technique"
      render :new
    end
  end

  def update
    @dams_technique.elementList.clear
    @dams_technique.scheme.clear
    @dams_technique.attributes = params[:dams_technique]
    if @dams_technique.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated technique"
        else      
        	redirect_to @dams_technique, notice: "Successfully updated technique"
        end
    else
      flash[:alert] = "Unable to save technique"
      render :edit
    end
  end

end
