module ApplicationHelper

  #Highlighting SOLR content 
  def field_with_highlighting document, field, sep='--'
	if(@response['highlighting'][document.get(:id)])
		return @response['highlighting'][document.get(:id)][field].join(sep) unless @response['highlighting'][document.get(:id)][field].blank?
	end
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
