class DamsCulturalContextsController < ApplicationController
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
    @current_cultural_context = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsCulturalContext"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_cultural_context = DamsCulturalContext.find(params[:id])
  end

  def new
    @dams_cultural_context.scheme.build
    @dams_cultural_context.elementList.culturalContextElement.build
	@mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_cultural_context.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_cultural_context.save
	    if(!params[:parent_id].nil?)
			redirect_to view_dams_cultural_context_path(@dams_cultural_context, {:parent_id => params[:parent_id]})
	    elsif(!params[:parent_class].nil?)
			redirect_to view_dams_cultural_context_path(@dams_cultural_context, {:parent_class => params[:parent_class]}) 	    			 	    
	    else    
        	redirect_to @dams_cultural_context, notice: "CulturalContext has been saved"
        end
    else
      flash[:alert] = "Unable to save CulturalContext"
      render :new
    end
  end

  def update
    # Unclear if list memebers can be updated by id, so just clear the list
    @dams_cultural_context.elementList.clear

    # Since the id (rdf_subject) is what we're looking to change for a scheme, we can't update it.
    # Must clear and re-add
    @dams_cultural_context.scheme.clear

    @dams_cultural_context.attributes = params[:dams_cultural_context]
    if @dams_cultural_context.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated CulturalContext."
        else
        	redirect_to @dams_cultural_context, notice: "Successfully updated CulturalContext"
        end            
    else
      flash[:alert] = "Unable to save CulturalContext"
      render :edit
    end
  end

end
