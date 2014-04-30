class DamsRelatedResourcesController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :show]
  after_action 'audit("#{@dams_related_resource.id}")', :only => [:create, :update]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @dams_related_resource = @document['name_tesim']
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsRelatedResource"' )
  end


  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def new

  end

  def edit

  end

  def create
    #@dams_related_resource.attributes = params[:dams_related_resource]
    if @dams_related_resource.save
     	if(!params[:parent_id].nil?)
			redirect_to dams_related_resource_path(@dams_related_resource, {:parent_id => params[:parent_id]})
	    elsif(!params[:parent_class].nil?)
			redirect_to dams_related_resource_path(@dams_related_resource, {:parent_class => params[:parent_class]}) 	    			 	    
	    else    
        	redirect_to @dams_related_resource, notice: "RelatedResource has been saved"
        end
    else
      flash[:alert] = "Unable to save DAMSRelatedResource"
      render :new
    end
  end

  def update
    @dams_related_resource.attributes = params[:dams_related_resource]
    if @dams_related_resource.save
        redirect_to dams_related_resource_path(@dams_related_resource), notice: "Successfully updated DAMSRelatedResource"
    else
      flash[:alert] = "Unable to save DAMSRelatedResource"
      render :edit
    end
  end

end
