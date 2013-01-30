class DamsVocabsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @vocab = DamsVocab.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_vocab.attributes = params[:dams_vocab]
    if @dams_vocab.save
        redirect_to @dams_vocab, notice: "Vocab has been saved"
    else
      flash[:alert] = "Unable to save vocab"
      render :new
    end
  end

  def update
    @dams_vocab.attributes = params[:dams_vocab]
    if @dams_vocab.save
        redirect_to @dams_vocab, notice: "Successfully updated vocab"
    else
      flash[:alert] = "Unable to save vocab"
      render :edit
    end
  end

  def index
    @vocabs = DamsVocab.all
  end


end
