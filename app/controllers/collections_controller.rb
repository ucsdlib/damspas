class CollectionsController < ApplicationController
  def show
    @response, @document = get_solr_response_for_doc_id
  end
  def index
    @response, @document = get_solr_response_for_field_values 'type_tesim', 'Collection'
  end
end
