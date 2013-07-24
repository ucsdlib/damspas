class MadsGenreFormsController < ApplicationController
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
    @current_genre_form = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_genre_forms = MadGenreForm.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsGenreForm"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_genre_form = MadsGenreForm.find(params[:id])
  end

  def new
	@mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_genre_form = MadsGenreForm.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    if(@mads_genre_form.scheme != nil)
    	@scheme_id = @mads_genre_form.scheme.to_s.gsub /.*\//, ""
    	#@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end       
  end

  def create
    @mads_genre_form.attributes = params[:mads_genre_form]
    if @mads_genre_form.save
        redirect_to @mads_genre_form, notice: "genre_form has been saved"
    else
      flash[:alert] = "Unable to save genre_form"
      render :new
    end
  end

  def update
    @mads_genre_form.attributes = params[:mads_genre_form]
    if @mads_genre_form.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated genre_form"
        else      
        	redirect_to @mads_genre_form, notice: "Successfully updated genre_form"
        end
    else
      flash[:alert] = "Unable to save genre_form"
      render :edit
    end
  end

end
