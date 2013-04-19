module DamsUnitsHelper
  def browse_facet_links
    CatalogController.blacklight_config.facet_fields.values
  end

  def render_unit_search_bar
    render :partial=> 'dams_units/search_form'
  end

  def current_unit
    @dams_unit
  end

  def render_unit_list
    #stub unit list
    render :partial => "dams_units/unit_links", :collection => @document.each, :as => :unit
  end

  def render_browse_facet_links
    facet_links = browse_facet_links
    facet_links.delete_if {|x| x.field == "unit_sim" || x.field == "collection_sim" } # don't show Browse By Unit links on landing pages
    render :partial => "dams_units/browse_facet_link", :collection => facet_links, :as => :facet
  end
end
