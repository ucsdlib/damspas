class UnitsController < ApplicationController
  include Blacklight::Catalog

  def show
    parm={ :q => "unit_code_tesim:#{params[:id]} AND type_tesim:DamsUnit" }
    @document = get_single_doc_via_search(1,parm)
    @current_unit = @document['unit_name_tesim']
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel AND unit_code_tesim:#{params[:id]}", :qt=>"standard")
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsUnit"' )
    @carousel_resp, @carousel = get_search_results( :q => "title_tesim:carousel")
  end
end
