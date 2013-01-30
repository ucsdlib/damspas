module DamsLanguagesHelper
  def render_language_list 
    #stub language list
    render :partial => "dams_languages/language_links", :collection => DamsLanguage.all, :as => :dams_language
  end

  def current_language
    @language
  end
  private 
end
