class DamsVocabularyEntriesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_vocabulary_entry = DamsVocabularyEntry.find(params[:id])
    @dams_vocabs = DamsVocabulary.find(:all)
  end

  def new
	@dams_vocabs = DamsVocabulary.find(:all)
  end

  def edit

  end

  def create
    @dams_vocabulary_entry.attributes = params[:dams_vocabulary_entry]
    if !@dams_vocabulary_entry.vocabulary.nil? && @dams_vocabulary_entry.vocabulary.to_s.length > 0
    	@dams_vocabulary_entry.vocabulary = "http://library.ucsd.edu/ark:/20775/"+@dams_vocabulary_entry.vocabulary.to_s
    else
    	@dams_vocabulary_entry.vocabulary = "http://library.ucsd.edu/ark:/20775/bb43434343" #language is probably not a good default...
    end
    if @dams_vocabulary_entry.save
        redirect_to @dams_vocabulary_entry, notice: "Vocabulary Entry has been saved"
    else
      flash[:alert] = "Unable to save vocabulary entry"
      render :new
    end
  end

  def update
    @dams_vocabulary_entry.attributes = params[:dams_vocabulary_entry]
    if @dams_vocabulary_entry.save
        redirect_to @dams_vocabulary_entry, notice: "Successfully updated vocabulary entry"
    else
      flash[:alert] = "Unable to save vocabulary entry"
      render :edit
    end
  end

  def index
    @vocabulary_entries = DamsVocabularyEntry.all
  end


end
