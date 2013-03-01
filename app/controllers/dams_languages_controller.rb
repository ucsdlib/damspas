class DamsLanguagesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_language = DamsLanguage.find(params[:id])
  end

  def new
	@dams_vocabularies = DamsVocabulary.find(:all)
  end

  def edit

  end

  def create
    @dams_language.attributes = params[:dams_language]
    @dams_language.vocabulary = Rails.configuration.lang_vocab
    if @dams_language.save
        redirect_to @dams_language, notice: "Language has been saved"
    else
      flash[:alert] = "Unable to save language"
      render :new
    end
  end

  def update
    @dams_language.attributes = params[:dams_language]
    if @dams_language.save
        redirect_to @dams_language, notice: "Successfully updated language"
    else
      flash[:alert] = "Unable to save language"
      render :edit
    end
  end

  def index
    @languages = DamsLanguage.all
  end


end
