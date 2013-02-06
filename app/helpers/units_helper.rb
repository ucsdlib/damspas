module UnitsHelper
  def render_unit_list 
    #stub unit list
    render :partial => "units/unit_links", :collection => @document.each, :as => :unit
  end

  def render_browse_facet_links
    render :partial => "units/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def browse_facet_links
    CatalogController.blacklight_config.facet_fields.values
  end

  def render_unit_search_bar
    render :partial=> 'units/search_form'
  end

  private 
end
