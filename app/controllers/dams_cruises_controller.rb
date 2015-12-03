class DamsCruisesController < ApplicationController
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
    @current_cruise = @document['name_tesim']
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
  
  def index
    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsCruise"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
end
