class MadsAuthorityController < ApplicationController
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
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsAuthority"' )
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_authority = MadsAuthority.find(params[:id])
    @mads_schemes = MadsScheme.find(:all)
    @scheme_id = @mads_authority.scheme.first.to_s.gsub /.*\//, ""
    @scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
  end
  def new
	@mads_schemes = MadsScheme.find(:all)
  end
  def edit
    @scheme_id = @mads_authority.scheme.first.to_s.gsub /.*\//, ""
  end

  def create
    @mads_authority.attributes = params[:mads_authority]
    if @mads_authority.save
        redirect_to @mads_authority, notice: "Authority has been saved"
    else
      flash[:alert] = "Unable to save authority"
      render :new
    end
  end

  def update
    @mads_authority.attributes = params[:mads_authority]
    if @mads_authority.save
        redirect_to @mads_authority, notice: "Successfully updated authority"
    else
      flash[:alert] = "Unable to save authority"
      render :edit
    end
  end

end
