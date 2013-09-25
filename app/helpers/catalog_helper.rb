module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
	opts[:label] ||= blacklight_config.index.show_link.to_sym
    if blacklight_config.highlighting
      label = field_with_highlighting doc, opts[:label], opts[:sep]
      label = render_document_index_label doc, opts if (label == nil || label.blank?)
    elsif doc['title_json_tesim'] != nil
      titlehash = JSON.parse doc['title_json_tesim'].first
      if titlehash['subtitle'] != nil
        label = "#{titlehash['value']}: #{titlehash['subtitle']}".html_safe
      else
        label = titlehash['value'].html_safe
      end
    else
      label = render_document_index_label( doc, opts ).html_safe
    end
    if doc['type_tesim'] != nil && doc['type_tesim'].include?("Collection")
      url = dams_collection_path(doc, :counter => opts[:counter] )
    else
      url = dams_object_path(doc, :counter => opts[:counter] )
    end
    link_to label, url, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end
  
  def should_render_index_field? document, solr_field
  	if !(solr_field.is_a? Symbol) && !(solr_field.is_a? String)
		hitsonly = solr_field.hitsonly
	end
	if (hitsonly)
		return document.has_highlight_field? solr_field.field
	else
		return document.has?(solr_field.field) ||
			(document.has_highlight_field? solr_field.field if solr_field.highlight)
	end
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

  def date_list( document )
    dateVal = ''
    dates = document['date_json_tesim']
    if dates != nil
      dates.each do |txt|
        date = JSON.parse(txt)
        if date['value']
          dateVal += ", " if !dateVal.blank?
          dateVal += date['value']
        elsif date['beginDate']
          dateVal += ", " if !dateVal.blank?
          dateVal += date['beginDate']
        elsif date['endDate']
          dateVal += ", " if !dateVal.blank?
          dateVal += date['endDate']
        end
      end
    end
    dateVal
  end
  def is_collection?( document )
    type = document['type_tesim']
    type != nil && type.include?("Collection")
  end
end
