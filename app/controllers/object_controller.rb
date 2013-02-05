class ObjectController < ApplicationController
  def show
    @response, @document = get_solr_response_for_doc_id
  end
end
