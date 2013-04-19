class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog

  def show
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
  end
  def index
    @response, @document = get_search_results( :q => "type_tesim:'Collection'", :rows => '50', :sort => 'col_name_ssi asc' )
  end
end
