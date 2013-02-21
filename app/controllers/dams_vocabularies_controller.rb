class DamsVocabulariesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @vocabulary = DamsVocabulary.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_vocabulary.attributes = params[:dams_vocabulary]
    if @dams_vocabulary.save
        redirect_to @dams_vocabulary, notice: "Vocabulary has been saved"
    else
      flash[:alert] = "Unable to save vocabulary"
      render :new
    end
  end

  def update
    @dams_vocabulary.attributes = params[:dams_vocabulary]
    if @dams_vocabulary.save
        redirect_to @dams_vocabulary, notice: "Successfully updated vocabulary"
    else
      flash[:alert] = "Unable to save vocabulary"
      render :edit
    end
  end

  def index
    @vocabularies = DamsVocabulary.all
  end


end
