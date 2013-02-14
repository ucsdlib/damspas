module DamsProvenanceCollectionPartsHelper
  def render_provenance_collection_part_list 
    #stub provenance collection list
    render :partial => "dams_provenance_collection_parts/provenance_collection_part_links", :collection => DamsProvenanceCollectionPart.all, :as => :dams_provenance_collection_part
  end

  def render_browse_facet_links
    render :partial => "dams_provenance_collection_parts/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def current_provenance_collection_part
    @dams_provenance_collection_part
  end
  private 
end
