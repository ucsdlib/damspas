module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label => nil, :counter => nil, :results_view => true, :force_label => false})

    opts[:label] ||= blacklight_config.index.show_link.to_sym

    if opts[:force_label]
      label = render_document_index_label( doc, opts ).html_safe
    else

      if doc['title_json_tesim'] != nil
        titlehash = JSON.parse doc['title_json_tesim'].first
        
        label = getFullTitle(titlehash).gsub('""', '"').html_safe
        label += ": #{titlehash['subtitle']}".gsub('""', '"').html_safe if !titlehash['subtitle'].blank?
      end
    end

    if doc['type_tesim'] != nil && doc['type_tesim'].include?("Collection")
      url = dams_collection_path(doc, :counter => opts[:counter] )
    else
      url = dams_object_path(doc, :counter => opts[:counter] )
    end

    link_to label, url, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :force_label, :results_view].include? k  })

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

  # Is facet value in adv facet search results?
  def facet_checked?(field, value, params)
    params.has_key?('f') && params['f'].has_key?(field) && params['f'][field].include?(value)
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

  # new blacklight-standard thumbnail url function
  def thumbnail_url( solr_doc = {}, image_options = {} )
    url = solr_doc['thumbnail_tesim']
    if url.kind_of? Array
      url = url.first
    end

    # translate PURLs into local URLs
    if !url.blank? && url.start_with?( Rails.configuration.id_namespace )
      url = url.sub( Rails.configuration.id_namespace, "" )
      parts = url.split(/\//,2)
      url = file_path parts[0], "_" + parts[1].gsub("/","_")
    end

    image_tag( url, :alt => "", :class => 'dams-search-thumbnail') unless url.blank?
  end

  def restricted_object_url()
    url = "http://libraries.ucsd.edu/assets/dams/site/thumb-restricted.png"
    
    image_tag( url, :alt => "", :class => 'dams-search-thumbnail')
  end
    
  def document_icon( document )
    # generic default icon
    resultClass = 'thumb-simple'
    resultIcon = 'glyphicon-file'

    if document['files_tesim'] != nil

      # SIMPLE OBJECT: look for preview image or format-appropriate icon
      fieldData = document['files_tesim']
      simpleUse = nil

      if fieldData != nil
        fieldData.each do |datum|
          files = JSON.parse(datum)
          if files["use"].end_with?("-service")
            simpleUse = files["use"]
            break
          end
        end
      end
      resultClass = 'thumb-simple'
      resultIcon = grabGlyphicon(simpleUse)

    elsif document['component_count_isi'] != nil

      # COMPLEX OBJECT: generic container icon
      if document['component_count_isi'] > 0
        resultClass = 'thumb-complex'
        resultIcon = 'glyphicon-folder-open'
      end

    elsif is_collection?(document)

      # COLLECTION: thumbnails URL in related resource
      resultClass = 'thumb-collection'
      resultIcon = 'glyphicon-th'

    end

    [resultClass, resultIcon]
  end

  # Determines which Bootstrap Glyphicon to use based on a component's file type
  #
  # @param fileUse The component's file use (type/role) value. E.g.,
  #    "image-service", "audio-service", etc.
  # @return A string that is the CSS class name of the Glyphicon to display.
  # @author David T.
  def grabGlyphicon(fileUse)
    icon = grabFileType(fileUse)
    case icon
      when 'image'
        icon = 'glyphicon-picture'
      when 'audio'
        icon = 'glyphicon-music'
      when 'video'
        icon = 'glyphicon-film'
      when 'no-files'
        icon = 'glyphicon-stop'
      else
        icon ='glyphicon-file'
    end
    return icon
  end
end
