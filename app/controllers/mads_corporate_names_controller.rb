class MadsCorporateNamesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_corporate_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_corporate_names = MadsCorporateName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsCorporateName"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_corporate_name = MadsCorporateName.find(params[:id])
  end

  def new

  end

  def edit
    #@mads_corporate_name = MadsCorporateName.find(params[:id])
  end

  def create
    @mads_corporate_name.attributes = params[:mads_corporate_name]
    if @mads_corporate_name.save
        redirect_to @mads_corporate_name, notice: "corporate_name has been saved"
    else
      flash[:alert] = "Unable to save corporate_name"
      render :new
    end
  end

  def update
    @mads_corporate_name.attributes = params[:mads_corporate_name]
    if @mads_corporate_name.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated corporate_name"
        else      
        	redirect_to @mads_corporate_name, notice: "Successfully updated corporate_name"
        end
    else
      flash[:alert] = "Unable to save corporate_name"
      render :edit
    end
  end

end
