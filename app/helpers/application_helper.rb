module ApplicationHelper
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

    
  def breadcrumbs(url)
    s = ""
  #  url = request.path.split('?')  #remove extra query string parameters
    levels = url[0].split('/') #break up url into different levels
    levels.each_with_index do |level, index|
      unless level.blank?
        if index == levels.size-1 || 
           (level == levels[levels.size-2] && levels[levels.size-1].to_i > 0)
          s += "<li>#{level.gsub(/_/, ' ')}</li>\n" unless level.to_i > 0
        else
            link = "/"
            i = 1
            while i <= index
              link += "#{levels[i]}/"
              i+=1
            end
            s += "<li><a href=\"#{link}\">#{level.gsub(/_/, ' ')}</a></li>\n"
        end
      end
   end
 end
end 
