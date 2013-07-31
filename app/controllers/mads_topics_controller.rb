class MadsTopicsController < ApplicationController
  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @current_topic = @document['name_tesim']
    #@carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND id_t:#{params[:id]}", :qt=>"standard")
     @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  def index
    # hydra index
    #@mads_topics = MadsTopic.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsTopic"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end

  ##############################################################################
  # hydra actions ##############################################################
  ##############################################################################
  def view
    @mads_topic = MadsTopic.find(params[:id])
   
  end

  def new
    @mads_topic.elementList.build
    @mads_topic.elementList.first.topicElement.build
  	@mads_schemes = MadsScheme.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @mads_topic = MadsTopic.find(params[:id])
    @mads_schemes = MadsScheme.find(:all)
    @scheme_id = @mads_topic.scheme.to_s.gsub /.*\//, ""
    @scheme_name = @mads_schemes.find_all{|s| s.pid == @scheme_id}[0].name.first   
  end

  def create
    @mads_topic.attributes = params[:mads_topic]
    if @mads_topic.save
        redirect_to @mads_topic, notice: "Topic has been saved"
    else
      flash[:alert] = "Unable to save Topic"
      render :new
    end
  end

  def update
    @mads_topic.attributes = params[:mads_topic]
    if @mads_topic.save
		if(!params[:parent_id].nil? && params[:parent_id].to_s != "")
        	redirect_to edit_mads_complex_subject_path(params[:parent_id]), notice: "Successfully updated Topic."
        else
        	redirect_to @mads_topic, notice: "Successfully updated Topic"
        end            
    else
      flash[:alert] = "Unable to save Topic"
      render :edit
    end
  end

end
