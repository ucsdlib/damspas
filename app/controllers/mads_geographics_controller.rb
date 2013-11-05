class MadsGeographicsController < ApplicationController
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
    @current_geographic = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_geographics = MadsGeographic.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsGeographic"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_geographic = MadsGeographic.find(params[:id])
  end

  def new
    @mads_geographic.elementList.geographicElement.build
    @mads_geographic.scheme.build
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
    @scheme_id = Rails.configuration.id_namespace+@mads_geographic.scheme.to_s.gsub(/.*\//,'')[0..9]  
  end

  def create
    if @mads_geographic.save
	    if(!params[:parent_id].nil?)
			redirect_to view_mads_geographic_path(@mads_geographic, {:parent_id => params[:parent_id]})
	    elsif(!params[:parent_class].nil?)
			redirect_to view_mads_geographic_path(@mads_geographic, {:parent_class => params[:parent_class]}) 	    			 	    
	    else    
        	redirect_to @mads_geographic, notice: "Geographic has been saved"
        end
    else
      flash[:alert] = "Unable to save Geographic"
      render :new
    end
  end

  def update
    @mads_geographic.elementList.clear

    # Since the id (rdf_subject) is what we're looking to change for a scheme, we can't update it.
    # Must clear and re-add
    @mads_geographic.scheme.clear
    @mads_geographic.attributes = params[:mads_geographic]
    if @mads_geographic.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated Geographic"
        else      
        	redirect_to @mads_geographic, notice: "Successfully updated Geographic"
        end
    else
      flash[:alert] = "Unable to save Geographic"
      render :edit
    end
  end

end
