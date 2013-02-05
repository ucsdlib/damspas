module DamsUnitsHelper
  def render_unit_list 
    #stub unit list
    render :partial => "dams_units/unit_links", :collection => DamsUnit.all, :as => :dams_unit
  end

  def render_browse_facet_links
    render :partial => "dams_units/browse_facet_link", :collection => browse_facet_links, :as => :facet
  end

  def browse_facet_links
    CatalogController.blacklight_config.facet_fields.values
  end

  def render_unit_search_bar
    render :partial=> 'dams_units/search_form'
  end

  def current_unit
    @unit
  end
  private 
end
