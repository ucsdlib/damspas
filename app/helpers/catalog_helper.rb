module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts
    link_to label, object_path(doc), { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end
  
  #use blacklight add_facet_params to construct facet link
  #see sufia for reference if need to add more: https://github.com/psu-stewardship/sufia/blob/master/app/helpers/sufia_helper.rb
  # field = field value (i.e. Academic Dissertations)
  # field_string = facet defined in catalog_controller.rb
  def link_to_facet(field, field_string)
    link_to(field, add_facet_params(field_string, field).merge!({"controller" => "catalog", :action=> "index"}))
  end

end
