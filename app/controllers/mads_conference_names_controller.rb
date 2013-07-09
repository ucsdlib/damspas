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
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsConferenceName"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_conference_name = MadsConferenceName.find(params[:id])
  end

  def new
    @mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @mads_conference_name = MadsConferenceName.find(params[:id])
    @mads_schemes = MadsScheme.find(:all)
    if(@mads_conference_name.scheme != nil)
      @scheme_id = @mads_conference_name.scheme.to_s.gsub /.*\//, ""
      @scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end  
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
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated confernce_name"
        else        
        	redirect_to @mads_conference_name, notice: "Successfully updated conference_name"
        end
    else
      flash[:alert] = "Unable to save conference_name"
      render :edit
    end
  end

end
