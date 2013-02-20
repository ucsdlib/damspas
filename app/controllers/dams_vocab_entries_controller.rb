class DamsVocabEntriesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_vocab_entry = DamsVocabEntry.find(params[:id])
    @dams_vocabs = DamsVocab.find(:all)
  end

  def new
	@dams_vocabs = DamsVocab.find(:all)
  end

  def edit

  end

  def create
    @dams_vocab_entry.attributes = params[:dams_vocab_entry]

    if !@dams_vocab_entry.vocabulary.nil? && @dams_vocab_entry.vocabulary.to_s.length > 0
    	@dams_vocab_entry.vocabulary = "http://library.ucsd.edu/ark:/20775/"+@dams_vocab_entry.vocabulary.to_s
    else
    	@dams_vocab_entry.vocabulary = "http://library.ucsd.edu/ark:/20775/bb43434343"
    end
    if @dams_vocab_entry.save
        redirect_to @dams_vocab_entry, notice: "Vocabulary Entry has been saved"
    else
      flash[:alert] = "Unable to save vocabulary entry"
      render :new
    end
  end

  def update
    @dams_vocab_entry.attributes = params[:dams_vocab_entry]
    if @dams_vocab_entry.save
        redirect_to @dams_vocab_entry, notice: "Successfully updated vocabulary entry"
    else
      flash[:alert] = "Unable to save vocabulary entry"
      render :edit
    end
  end

  def index
    @vocab_entries = DamsVocabEntry.all
  end


end
