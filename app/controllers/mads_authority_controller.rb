class MadsAuthorityController < ApplicationController
  include Blacklight::Catalog
  include Dams::ControllerHelper  
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :show]

  ##############################################################################
  # solr actions ###############################################################
  ##############################################################################
  def show
    parm={ :q => "id:#{params[:id]}" }
    @document = get_single_doc_via_search(1,parm)
  end
  def index
    @response, @document = get_search_results(:q => 'has_model_ssim:"info:fedora/afmodel:MadsAuthority"' )
  end
end
