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

  end

  def edit
    #@mads_genre_form = MadsGenreForm.find(params[:id])
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
        redirect_to @mads_genre_form, notice: "Successfully updated genre_form"
    else
      flash[:alert] = "Unable to save genre_form"
      render :edit
    end
  end

end
