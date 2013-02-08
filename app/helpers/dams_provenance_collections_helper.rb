module DamsProvenanceCollectionsHelper
  def render_provenance_collection_list 
    #stub provenance collection list
    render :partial => "dams_provenance_collections/provenance_collection_links", :collection => DamsProvenanceCollection.all, :as => :dams_provenance_collection
  end

  def render_browse_facet_links
    render :partial => "dams_provenance_collectiones/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def current_provenance_collection
    @dams_provenance_collection
  end
  private 
end
