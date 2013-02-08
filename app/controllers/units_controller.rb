class UnitsController < ApplicationController
  def show
    @response, @docs = get_solr_response_for_field_values 'unit_code_tesim', params[:id]
    @document = @docs.first
    @current_unit = @document['unit_id_tesim']
  end
  def index
    @response, @document = get_solr_response_for_field_values 'has_model_ssim', 'info:fedora/afmodel:DamsUnit'
  end
end
