class SearchController < ApplicationController
  def index
    @response, @document = get_solr_response_for_field_values 'has_model_ssim', 'info:fedora/afmodel:DamsUnit'
  end
  def show
    @response, @document = get_solr_response_for_doc_id
    @current_unit = params[:id]
  end
end
