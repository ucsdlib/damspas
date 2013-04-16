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
	if highlighting
		highlight_values = document.highlight_field(field)
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
				return highlight_values.first
			end
		elsif (document[field].count > highlight_values.count)
			#Merge the highlighting values for the view.
			values = document[field].dup
			for v in highlight_values do
				vo = v.gsub('<em>', '').gsub('</em>', '')
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
			return highlight_values.join(sep).html_safe
		end
	end
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
    base_title = "Digital Library Collections"
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
 
end 
