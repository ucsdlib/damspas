class MadsFamilyNamesController < ApplicationController
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
    @current_family_name = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_family_names = MadFamilyName.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsFamilyName"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_family_name = MadsFamilyName.find(params[:id])
  end

  def new
    @mads_family_name.elementList.fullNameElement.build
    @mads_family_name.scheme.build           
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @mads_family_name = MadsFamilyName.find(params[:id])
    @mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
    @scheme_id = Rails.configuration.id_namespace+@mads_family_name.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @mads_family_name.save
      if(!params[:parent_id].nil?)
        redirect_to view_mads_family_name_path(@mads_family_name, {:parent_id => params[:parent_id]})
      elsif(!params[:parent_class].nil?)
        redirect_to view_mads_family_name_path(@mads_family_name, {:parent_class => params[:parent_class]})                   
      else    
        redirect_to @mads_family_name, notice: "FamilyName has been saved"
      end
    else
      flash[:alert] = "Unable to save FamilyName"
      render :new
    end
  end

  def update
    @mads_family_name.elementList.clear
    @mads_family_name.scheme.clear 
    @mads_family_name.attributes = params[:mads_family_name]
    if @mads_family_name.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated FamilyName"
        else      
        	redirect_to @mads_family_name, notice: "Successfully updated FamilyName"
        end
    else
      flash[:alert] = "Unable to save FamilyName"
      render :edit
    end
  end

end
