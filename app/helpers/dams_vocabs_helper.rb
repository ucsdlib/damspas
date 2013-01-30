module DamsVocabsHelper
  def render_vocab_list 
    #stub vocab list
    render :partial => "dams_vocabs/vocab_links", :collection => DamsVocab.all, :as => :dams_vocab
  end

  def current_vocab
    @vocab
  end
  private 
end
