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
    if defined?(componentIndex) # Then we're working with a component
      prefix = "component_#{componentIndex}_"
    else 
      prefix = ''
    end
    puts "prepre" + prefix
    dates = document["#{prefix}date_json_tesim"]
    if dates != nil
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
  if dates.empty?
	dates << datehash['beginDate'] unless datehash['beginDate']==nil?
end
if dates.empty?
	dates << datehash['endDate'] unless datehash['endDate']==nil?
end
	return dates.map { |v|v }.join(sep).html_safe
  end
  
  # render page titles for all application pages using Digital Library Collections prefix
  def full_title(page_title)
    base_title = 'UC San Diego Library Digital Collections'
    if(page_title.blank?)
      base_title
    else
      "#{base_title} | #{page_title}"
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
    link_to_function name, "remove_fields(this)"
  end

  def link_to_delete_fields(name)
    link_to_function name, "remove_fields(this)"
  end
      
  def link_to_add_fields(name, f, association, type, objectType)
    new_object = type.constantize.new()
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("shared/edit_fields/"+association.to_s.singularize + "_fields", :f => builder, :object_type => objectType, :is_first => "false")
    end
    link_to_function name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"
  end 

  def link_to_add_edit_fields(name, f, association, objectType)
    fields = render("shared/edit_fields/"+association.to_s.singularize + "_edit_fields", :f => f, :object_type => objectType)

    link_to_function name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"
  end
  
  def link_to_add_subjects(name, f, objectType, subjectTypeArray )
    fields = render("shared/edit_fields/simple_subjects_fields", :f => f, :object_type => objectType, :subjectTypeArray => subjectTypeArray)

    link_to_function name, "add_subject_fields(this, \"#{escape_javascript(fields)}\")"
  end

  def link_to_add_edit_subjects(name, f, objectType, subjectTypeArray, index)
    fields = render("shared/edit_fields/simple_subjects_edit_fields", :f => f, :object_type => objectType, :subjectTypeArray => subjectTypeArray, :selected_type => nil)
    link_to_function name, "add_subject_fields(this, \"#{escape_javascript(fields)}\")"
  end        

  def link_to_add_creators(name, f, objectType, nameTypeArray )
    fields = render("shared/edit_fields/creator_fields", :f => f, :object_type => objectType, :nameTypeArray => nameTypeArray)

    link_to_function name, "add_name_fields(this, \"#{escape_javascript(fields)}\")"
  end 
  def link_to_add_edit_creators(name, f, objectType, nameTypeArray, index)
    fields = render("shared/edit_fields/creator_edit_fields", :f => f, :object_type => objectType, :nameTypeArray => nameTypeArray, :selected_type => nil)
    link_to_function name, "add_name_fields(this, \"#{escape_javascript(fields)}\")"
  end
  
  def link_to_add_relationships(name, f, objectType, nameTypeArray )
    fields = render("shared/edit_fields/relationship_fields", :f => f, :object_type => objectType, :nameTypeArray => nameTypeArray)

    link_to_function name, "add_relationship_fields(this, \"#{escape_javascript(fields)}\")"
  end
  
  def link_to_add_edit_relationships(name, f, objectType, nameTypeArray, index)
    fields = render("shared/edit_fields/relationship_edit_fields", :f => f, :object_type => objectType, :nameTypeArray => nameTypeArray, :selected_type => nil)
    link_to_function name, "add_relationship_fields(this, \"#{escape_javascript(fields)}\")"
  end    
end 
