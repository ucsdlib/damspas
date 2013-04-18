class CollectionsController < ApplicationController
  include Blacklight::Catalog

  def show
    @response, @document = get_solr_response_for_doc_id
  end
  def index
    @response, @document = get_solr_response_for_field_values 'type_tesim', 'Collection', {:rows => '50', :sort => 'col_name_ssi asc'}
  end
end
