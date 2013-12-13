class MadsAuthorityController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper  
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
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = @mads_authority.scheme.to_s.gsub(/.*\//,'')[0..9]
    #@scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first
  end
  def new
	#@mads_schemes = MadsScheme.find(:all)
	@mads_authority.scheme.build
  	@mads_schemes = get_objects('MadsScheme','name_tesim')	
  end
  def edit
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@mads_authority.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    #@mads_authority.attributes = params[:mads_authority]
    if @mads_authority.save
	    if(!params[:parent_id].nil?)
			redirect_to view_mads_authority_path(@mads_authority, {:parent_id => params[:parent_id]})
	    elsif(!params[:parent_class].nil?)
			redirect_to view_mads_authority_path(@mads_authority, {:parent_class => params[:parent_class]}) 	    			 	    
	    else
        	redirect_to @mads_authority, notice: "Authority has been saved"
        end        
    else
      flash[:alert] = "Unable to save authority"
      render :new
    end
  end

  def update
  	@mads_authority.scheme.clear 
    @mads_authority.attributes = params[:mads_authority]
    if @mads_authority.save
        redirect_to @mads_authority, notice: "Successfully updated authority"
    else
      flash[:alert] = "Unable to save authority"
      render :edit
    end
  end

end
