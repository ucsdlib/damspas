module DamsVocabEntriesHelper
  def render_vocab_entry_list 
    #stub vocab list
    render :partial => "dams_vocab_entries/vocab_entry_links", :collection => DamsVocabEntry.all, :as => :dams_vocab_entry
  end

  def current_vocab_entry
    @vocab_entry
  end
  private 
end
