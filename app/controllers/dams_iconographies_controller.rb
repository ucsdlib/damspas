class DamsIconographiesController < ApplicationController
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
    @current_iconography = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@dams_iconographys = DamsIconography.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsIconography"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @dams_iconography = DamsIconography.find(params[:id])
  end

  def new
    #Check schemes ####################################################################
    @dams_iconography.scheme.build
    @dams_iconography.elementList.iconographyElement.build
	@mads_schemes = get_objects('MadsScheme','name_tesim')
  end

  def edit
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    @scheme_id = Rails.configuration.id_namespace+@dams_iconography.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @dams_iconography.save
	    if(!params[:parent_id].nil?)
			redirect_to view_dams_iconography_path(@dams_iconography, {:parent_id => params[:parent_id]})
	    elsif(!params[:parent_class].nil?)
			redirect_to view_dams_iconography_path(@dams_iconography, {:parent_class => params[:parent_class]}) 	    			 	    
	    else    
        	redirect_to @dams_iconography, notice: "iconography has been saved"
        end
    else
      flash[:alert] = "Unable to save iconography"
      render :new
    end
  end

  def update
    @dams_iconography.elementList.clear
    @dams_iconography.scheme.clear  
    @dams_iconography.attributes = params[:dams_iconography]
    if @dams_iconography.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_dams_complex_subject_path(params[:parent_id]), notice: "Successfully updated iconography"
        else      
        	redirect_to @dams_iconography, notice: "Successfully updated iconography"
        end
    else
      flash[:alert] = "Unable to save iconography"
      render :edit
    end
  end

end
