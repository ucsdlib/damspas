module DamsVocabulariesHelper
  def render_vocabulary_list 
    render :partial => "dams_vocabularies/vocabulary_links", :collection => DamsVocabulary.all, :as => :dams_vocabulary
  end

  def current_vocabulary
    @vocabulary
  end
  private 
end
