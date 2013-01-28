module DamsRepositoriesHelper
  def render_repository_list 
    #stub repository list
    render :partial => "dams_repositories/repository_links", :collection => DamsRepository.all, :as => :dams_repository
  end

  def render_browse_facet_links
    render :partial => "dams_repositories/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def browse_facet_links
    CatalogController.blacklight_config.facet_fields.values
  end

  def render_repository_search_bar
    render :partial=> 'dams_repositories/search_form'
  end

  def current_repository
    @repository
  end
  private 
end
