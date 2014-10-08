class DamsUnitsController < ApplicationController

  layout "homepage"

  include Blacklight::Catalog
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "unit_code_tesim:#{params[:id]} AND type_tesim:DamsUnit" }
    @document = get_single_doc_via_search(1,parm)
    @current_unit = @document['unit_name_tesim']
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND unit_code_tesim:#{params[:id]}", :qt=>"standard")
  end
  
  def index
    # hydra index
    #@dams_units = DamsUnit.all( :order=>"system_create_dtsi asc" )

    # solr index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsUnit"' )
    count_params = { :q => "has_model_ssim:\"info:fedora/afmodel:DamsObject\"", :rows => 0 }
    apply_gated_discovery( count_params, nil )
    @count_resp, @count_doc = get_search_results( count_params )
  end
end
