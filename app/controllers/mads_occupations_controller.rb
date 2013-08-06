class MadsOccupationsController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_occupation = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_occupations = MadOccupation.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsOccupation"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_occupation = MadsOccupation.find(params[:id])
  end

  def new
    @mads_occupation.elementList.occupationElement.build
    @mads_occupation.scheme.build
	@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @mads_schemes = MadsScheme.find(:all)
    @scheme_id = @mads_occupation.scheme.to_s.gsub /.*\//, ""    
  end

  def create
    if @mads_occupation.save
        redirect_to @mads_occupation, notice: "Occupation has been saved"
    else
      flash[:alert] = "Unable to save Occupation"
      render :new
    end
  end

  def update
    @mads_occupation.elementList.clear
    @mads_occupation.scheme.clear
    @mads_occupation.attributes = params[:mads_occupation]
    if @mads_occupation.save
    	if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated Occupation"
        else  
        	redirect_to @mads_occupation, notice: "Successfully updated Occupation"
        end
    else
      flash[:alert] = "Unable to save occupation"
      render :edit
    end
  end

end
