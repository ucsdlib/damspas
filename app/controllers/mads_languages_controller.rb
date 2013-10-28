class MadsLanguagesController < ApplicationController
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
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsLanguage"' )
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
     @mads_language = MadsLanguage.find(params[:id])
  end
  def new
    @mads_language.elementList.languageElement.build
    @mads_language.scheme.build
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end
  def edit
  	@mads_schemes = get_objects('MadsScheme','name_tesim')
    #@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
    @scheme_id = Rails.configuration.id_namespace+@mads_language.scheme.to_s.gsub(/.*\//,'')[0..9]
  end

  def create
    if @mads_language.save
	    if(!params[:popup].nil? && params[:popup].to_s == "true" && !params[:parent_id].nil?)
			redirect_to view_mads_language_path(@mads_language, {:parent_id => params[:parent_id]})
	    elsif(!params[:popup].nil? && params[:popup].to_s == "true" && !params[:parent_class].nil?)
			redirect_to view_mads_language_path(@mads_language, {:parent_class => params[:parent_class]}) 	    			 	    
	    else
        	redirect_to @mads_language, notice: "Language has been saved"
        end
    else
      flash[:alert] = "Unable to save Language"
      render :new
    end
  end

  def update
    @mads_language.elementList.clear
    @mads_language.scheme.clear  
    @mads_language.attributes = params[:mads_language]
    if @mads_language.save
        redirect_to mads_language_path(@mads_language), notice: "Successfully updated Language"
    else
      flash[:alert] = "Unable to save Language"
      render :edit
    end
  end

end
