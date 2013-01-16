class DamsVocabsController < ApplicationController
  before_filter :authenticate_user!, :only=>[:create]

  def new
    @dams_vocab = DamsVocab.new
  end

  # create
  def create
     @dams_vocab = DamsVocab.new(params[:dams_vocab].merge(:edit_users => [current_user.user_key ] ))
     respond_to do |format|
       if @dams_vocab.save
         format.html {redirect_to dams_vocabs_path, notice: 'Dams Vocabulary was successfuly created.'}
         format.json {render json: @dams_vocab, status: :created, location: @dams_vocab}
       else
         format.html {render action: "new"}
         format.json {render json: @dams_vocab.error, status: :unprocessable_entity}
       end
    end


  end
  
  def update
    @dams_vocab = DamsVocab.find(params[:id])
    #dams_vocab.save!
    #redirect_to dams_vocabs_path, :notice=>"Vocabulary Updated"
    respond_to do |format|
    if @dams_vocab.update_attributes(params[:dams_vocab])
        format.html { redirect_to edit_dams_vocab_path(@dams_vocab), notice: 'Dams Vocab was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dams_vocab.errors, status: :unprocessable_entity }
      end
   end

  end

  def index
    @dams_vocabs = DamsVocab.find(:all)
  end
  
  def destroy
    @dams_vocab = DamsVocab.destroy(params[:id])
    redirect_to dams_vocabs_path, :notice=>"Vocabulary is deleted"
  end

  def show
    @dams_vocab = DamsVocab.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dams_vocab }
      format.xml  { render xml: @dams_vocab }
    end
  end

  def edit
    @dams_vocab = DamsVocab.find(params[:id])
  end

  
end
