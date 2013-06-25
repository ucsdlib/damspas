class MadsSchemesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @mads_scheme = @document['name_tesim']
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsScheme"' )
  end


  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_scheme = MadsScheme.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @mads_scheme.attributes = params[:mads_scheme]
    if @mads_scheme.save
        redirect_to @mads_scheme, notice: "MADSScheme has been saved"
    else
      flash[:alert] = "Unable to save MADSScheme"
      render :new
    end
  end

  def update
    @mads_scheme.attributes = params[:mads_scheme]
    if @mads_scheme.save
        redirect_to view_mads_scheme_path(@mads_scheme), notice: "Successfully updated MADSScheme"
    else
      flash[:alert] = "Unable to save MADSScheme"
      render :edit
    end
  end

end
