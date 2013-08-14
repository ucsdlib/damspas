class DamsCollectionsController < ApplicationController
  include Blacklight::Catalog

  def show
    @document = get_single_doc_via_search(1, {:q => "id:#{params[:id]}"} )
  end
  def index
    @response, @document = get_search_results( {:q => "type_tesim:'Collection'", :rows => '200', :sort => 'title_ssi asc'}, {:fq => "-id:#{Rails.configuration.excluded_collections}"} )
    @response, @ProvenanceDocument = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsProvenanceCollection"', :rows => 100, :sort => 'title_ssi asc' )
     @response, @AssembledDocument = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:DamsAssembledCollection"', :rows => 100, :sort => 'title_ssi asc' )
     
    end
end
