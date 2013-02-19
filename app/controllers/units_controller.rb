class UnitsController < ApplicationController
  def show
    parm={ :q => "unit_code_tesim:#{params[:id]} AND type_tesim:DamsUnit" }
    @document = get_single_doc_via_search(1,parm)
    @current_unit = @document['unit_id_tesim']
  end
  def index
    @response, @document = get_solr_response_for_field_values 'has_model_ssim', 'info:fedora/afmodel:DamsUnit'
  end
end
