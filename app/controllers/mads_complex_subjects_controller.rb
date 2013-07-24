class MadsComplexSubjectsController < ApplicationController
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
    @current_subject = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsComplexSubject"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_complex_subject = MadsComplexSubject.find(params[:id])
  end

  def new
	@mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
    @mads_complex_subject = MadsComplexSubject.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    if(@mads_complex_subject.scheme != nil)
      @scheme_id = @mads_complex_subject.scheme.to_s.gsub /.*\//, ""
      #@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end      
  end

  def create
    @mads_complex_subject.attributes = params[:mads_complex_subject]
    if @mads_complex_subject.save
        redirect_to @mads_complex_subject, notice: "Subject has been saved"
    else
      flash[:alert] = "Unable to save Subject"
      render :new
    end
  end

  def update
    @mads_complex_subject.attributes = params[:mads_complex_subject]
    if @mads_complex_subject.save
        redirect_to @mads_complex_subject, notice: "Successfully updated subject"
    else
      flash[:alert] = "Unable to save subject"
      render :edit
    end
  end

end
