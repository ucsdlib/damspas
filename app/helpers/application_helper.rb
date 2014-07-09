module ApplicationHelper

  #Retrieve the highlighting content 
  def field_with_highlighting document, field, sep=field_value_separator
	highlighting = blacklight_config.highlighting
	if !(field.is_a? Symbol) && !(field.is_a? String)
		options = field
		field = options[:'field']
		highlighting = options[:'highlight']
		hitsonly = options[:'hitsonly']
	end
  if field == "date_tesim"
    return date_Val document
  end
	if highlighting
		highlight_values = document.highlight_field(field)
		
		#Snippets for no default indexed fields
		if(hitsonly && highlight_values != nil && highlight_values.count > 0)
			highlight_values.collect! {|m|m.length < blacklight_config.hlMaxFragsize || m.ends_with?(".") ? m : m+ " ..."}
			return highlight_values.join(sep).html_safe
		end
		highlight_values = document[field] if (highlight_values.nil? || highlight_values.count==0)
	elsif field.to_s.index('_json_')
		highlight_values = document[field]
	end
	if highlight_values != nil && highlight_values.count > 0 && !hitsonly
		if field.to_s.index('_json_')
			if field.to_s.index('title_')
				return parseJsonTitle highlight_values.first, sep 
			elsif field.to_s.index('date_')
				return parseJsonDate highlight_values.first, sep
			else
				return highlight_values.join(sep).html_safe
			end
		elsif (document[field].count > highlight_values.count)
			#Merge the highlighting values for the view.
			values = document[field].dup
			for v in highlight_values do
				vo = v.gsub(blacklight_config.hlTagPre, '').gsub(blacklight_config.hlTagPost, '')
				i = 0
				begin
					if values[i].eql? vo
						values[i] = v
						break
					end
					i+=1
				end while i < values.count
			end
			return values.map { |v|v }.join(sep).html_safe
		else
    # if field == "date_tesim"
    #   return highlight_values.first.html_safe
    # end
			return highlight_values.join(sep).html_safe
		end
	end
  end
  
  def date_Val document
    dateRet = ''
    i = 1
    #Looking at date_jason_tesim because the JSON allows for extrapolation of value/beginDate/endDate fields for each date
    dates = document["date_json_tesim"]  
    if dates != nil
      dateRet = dateHelper dates
    else
      pref = "component_#{i}_"
      dates = document["#{pref}date_json_tesim"]
      if dateRet.blank? && dates != nil
        dateRet = dateHelper dates
      end
    end    
    return dateRet 
  end

  def dateHelper dates
    dateRet = ''
    c2 = false
    c3 = false
    c4 = false
    dates.each do |data|
      date = JSON.parse(data)
      if date['type'].casecmp("creation") == 0 || date['type'].casecmp("created") == 0
        if date['value']
          dateRet = date['value']
        else
          dateRet = date['beginDate']
        end
        break
      elsif date['type'].casecmp("copyright") == 0 && dateRet.blank?
        if date['value']
          dateRet = date['value']
        else
          dateRet = date['beginDate']
        end
        c2 = true
      elsif date['type'].casecmp("published") == 0 && dateRet.blank? && !c2
        if date['value']
          dateRet = date['value']
        else
          dateRet = date['beginDate']
        end
        c3 = true
      elsif date['type'].casecmp("issued") == 0 && dateRet.blank? && !c2 && !c3
        if date['value']
          dateRet = date['value']
        else
          dateRet = date['beginDate']
        end
        c4 = true
      elsif !c2 && !c3 && !c4
        if date['value']
          dateRet = date['value']
        else
          dateRet = date['beginDate']
        end
      end
    end
    return dateRet
  end

  # Parsing the json title values
  def parseJsonTitle jsonString, sep
	titlehash = JSON.parse jsonString
	titles = Array.new
	titles << titlehash['value']
	titles << titlehash['subtitle'] if (titlehash['subtitle'] != nil && !titlehash['subtitle'].blank?)
	return titles.map { |v|v }.join(sep).html_safe
  end
  
  #Parsing the json date values
  def parseJsonDate jsonString, sep
	datehash = JSON.parse jsonString
	dates = Array.new
	dates << datehash['value'] unless datehash['value']==nil?
	dates << datehash['beginDate'] unless datehash['beginDate']==nil?
	dates << datehash['endDate'] unless datehash['endDate']==nil?
	return dates.map { |v|v }.join(sep).html_safe
  end
  
  # render page titles for all application pages using Digital Library Collections prefix
  def full_title(page_title)
    base_title = 'Digital Collections | UC San Diego Library'
    if(page_title.blank?)
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  # placeholder for rendering breadcrumbs
  # TODO: what is needed? action, controller?, page title?
  # params[:action],params[:controller],...

  def breadcrumbs
    result = "".html_safe

    association_chain.each_with_index do |item, index|
    # note that .name works for both classes and objects
    result << link_to(item.name.humanize.titlecase, association_chain[0..index])
    result << " &raquo; ".html_safe
    end
    result << resource.name.humanize.titleize 
  end
 
  def link_to_remove_fields(name, f)
    #f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    #link_to_function name, "remove_fields(this)"
    link_to_function(name, "remove_fields(this)", :class => 'removeField')
  end

  def link_to_delete_fields(name)
    link_to_function(name, "remove_fields(this)", :class => 'removeField')
  end
      
  def link_to_add_fields(name, f, association, type, objectType)
    new_object = type.constantize.new()
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("shared/edit_fields/"+association.to_s.singularize + "_fields", :f => builder, :object_type => objectType, :is_first => "false")
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'addField')
  end 

  def link_to_add_edit_fields(name, f, association, objectType)
    fields = render("shared/edit_fields/"+association.to_s.singularize + "_edit_fields", :f => f, :object_type => objectType)

    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'addField')
  end
  
  def link_to_add_dynamic_fields(name, f, objectType, typeArray, className, index, edit)
    if edit == 1
      fields = render("shared/edit_fields/#{className}_edit_fields", :f => f, :object_type => objectType, :typeArray => typeArray, :selected_type => nil)
    else
      fields = render("shared/edit_fields/#{className}_fields", :f => f, :object_type => objectType, :typeArray => typeArray)
    end
    link_to_function(name, "add_dynamic_fields(this, \"#{escape_javascript(fields)}\", \"#{escape_javascript(className.camelize)}\")", :class => 'addField')
  end
    
end 
