module DamsVocabularyEntriesHelper
  def render_vocabulary_entry_list 
    #stub vocabulary list
    render :partial => "dams_vocabulary_entries/vocabulary_entry_links", :collection => DamsVocabularyEntry.all, :as => :dams_vocabulary_entry
  end

  def current_vocabulary_entry
    @vocabulary_entry
  end
  private 
end
