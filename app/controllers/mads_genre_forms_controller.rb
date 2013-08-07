class MadsGenreFormsController < ApplicationController
  include Blacklight::Catalog
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
    @mads_genre_form.elementList.genreFormElement.build
    @mads_genre_form.scheme.build 
	@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
  	@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
    @scheme_id = Rails.configuration.id_namespace+@mads_genre_form.scheme.to_s.gsub(/.*\//,'')[0..9]   
  end

  def create
    if @mads_genre_form.save
        redirect_to @mads_genre_form, notice: "GenreForm has been saved"
    else
      flash[:alert] = "Unable to save GenreForm"
      render :new
    end
  end

  def update
    @mads_genre_form.elementList.clear
    @mads_genre_form.scheme.clear  
    @mads_genre_form.attributes = params[:mads_genre_form]
    if @mads_genre_form.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated GenreForm"
        else      
        	redirect_to @mads_genre_form, notice: "Successfully updated GenreForm"
        end
    else
      flash[:alert] = "Unable to save GenreForm"
      render :edit
    end
  end

end
