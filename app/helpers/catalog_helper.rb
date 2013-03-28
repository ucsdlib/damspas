module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    if doc['title_json_tesim'] != nil
      titlehash = JSON.parse doc['title_json_tesim'].first
      if titlehash['subtitle'] != nil
        label = "#{titlehash['value']}: #{titlehash['subtitle']}"
      else
        label = titlehash['value']
      end
    else
      label = render_document_index_label doc, opts
    end
    if doc['type_tesim'] != nil && doc['type_tesim'].include?("Collection")
      url = collection_path(doc)
    else
      url = object_path(doc)
    end
    link_to label, url, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end
  
  #use blacklight add_facet_params to construct facet link
  #see sufia for reference if need to add more: https://github.com/psu-stewardship/sufia/blob/master/app/helpers/sufia_helper.rb
  # field = field value (i.e. Academic Dissertations)
  # field_string = facet defined in catalog_controller.rb
  def link_to_facet(field, field_string)
    link_to(field, add_facet_params(field_string, field).merge!({"controller" => "catalog", :action=> "index"}))
  end

  def facet_uri(field, field_string)
    return add_facet_params(field_string, field).merge!({"controller" => "catalog", :action=> "index"})
  end
  
  #override of blacklight helper function: 
  # https://github.com/projectblacklight/blacklight/blob/master/app/helpers/blacklight/blacklight_helper_behavior.rb#L353
  # uses a semi-colon delimiter in for search result field values
  def field_value_separator
    '; '
  end

end
