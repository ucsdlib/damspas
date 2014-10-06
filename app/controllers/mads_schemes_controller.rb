class MadsSchemesController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id_t:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
    @mads_scheme = @document['name_tesim']
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsScheme"' )
  end
end
