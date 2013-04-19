class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog

  def show
    @response, @document = get_search_results( :q => "id:#{params[:id]}" )
  end
  def index
    @response, @document = get_search_results( :q => "type_tesim:'Collection'", :rows => '50', :sort => 'col_name_ssi asc' )
  end
end
