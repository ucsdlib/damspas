module DamsVocabulariesHelper
  def render_vocabularies_list 
    #stub vocabularies list
    render :partial => "dams_vocabulariess/vocabularies_links", :collection => DamsVocabulary.all, :as => :dams_vocabulary
  end

  def current_vocabulary
    @vocabulary
  end
  private 
end
