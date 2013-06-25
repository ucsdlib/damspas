class MadsLanguagesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsLanguage"' )
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_language = MadsLanguage.find(params[:id])
    @mads_schemes = MadsScheme.find(:all)
    #@scheme_id = @mads_language.scheme.first.to_s.gsub /.*\//, ""
    if(@mads_language.scheme != nil)
    	@scheme_id = @mads_language.scheme.pid
    	@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
    end
  end
  def new
	@mads_schemes = MadsScheme.find(:all)
  end
  def edit
    #@scheme_id = @mads_language.scheme.first.to_s.gsub /.*\//, ""
    if(@mads_language.scheme != nil)
    	@scheme_id = @mads_language.scheme.pid
    end
    @mads_schemes = MadsScheme.find(:all)
  end

  def create
    @mads_language.attributes = params[:mads_language]
    if @mads_language.save
        redirect_to @mads_language, notice: "language has been saved"
    else
      flash[:alert] = "Unable to save language"
      render :new
    end
  end

  def update
    @mads_language.attributes = params[:mads_language]
    if @mads_language.save
        redirect_to view_mads_language_path(@mads_language), notice: "Successfully updated language"
    else
      flash[:alert] = "Unable to save language"
      render :edit
    end
  end

end
