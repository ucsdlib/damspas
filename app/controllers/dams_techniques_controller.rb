class DamsTechniquesController < ApplicationController
  include Blacklight::Catalog
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
    @mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @dams_technique = DamsTechnique.find(params[:id])
    @mads_schemes = MadsScheme.find(:all)
    @scheme_id = @dams_technique.scheme.to_s.gsub /.*\//, ""
    @scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first   
  end

  def create
    @dams_technique.attributes = params[:dams_technique]
    if @dams_technique.save
        redirect_to @dams_technique, notice: "technique has been saved"
    else
      flash[:alert] = "Unable to save technique"
      render :new
    end
  end

  def update
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
