class MadsConferenceNamesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_conference_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_conference_names = MadsConferenceName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsConferenceName" AND NOT name_tesim:"conference Name Test" AND NOT name_tesim:"conference Name" AND NOT name_tesim:"Test Name"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_conference_name = MadsConferenceName.find(params[:id])
  end

  def new

  end

  def edit
    #@mads_conference_name = MadsConferenceName.find(params[:id])
  end

  def create
    @mads_conference_name.attributes = params[:mads_conference_name]
    if @mads_conference_name.save
        redirect_to @mads_conference_name, notice: "conference_name has been saved"
    else
      flash[:alert] = "Unable to save conference_name"
      render :new
    end
  end

  def update
    @mads_conference_name.attributes = params[:mads_conference_name]
    if @mads_conference_name.save
        redirect_to @mads_conference_name, notice: "Successfully updated conference_name"
    else
      flash[:alert] = "Unable to save conference_name"
      render :edit
    end
  end

end
