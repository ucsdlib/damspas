module DamsAssembledCollectionsHelper
  def render_assembled_collection_list 
    #stub assembled collection list
    render :partial => "dams_assembled_collections/assembled_collection_links", :collection => DamsAssembledCollection.all, :as => :dams_assembled_collection
  end

  def render_browse_facet_links
    render :partial => "dams_assembled_collectiones/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def current_assembled_collection
    @dams_assembled_collection
  end
  private 
end
