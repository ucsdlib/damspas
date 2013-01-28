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
  def breadcrumbs()
    base_breadcrumb = "Home"
  end
end
