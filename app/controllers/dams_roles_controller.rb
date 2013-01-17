class DamsRolesController < ApplicationController
  before_filter :authenticate_user!, :only=>[:create]

  # new
  def new
    @dams_role = DamsRole.new
  end

  # create
  def create
    @dams_role = DamsRole.new(params[:dams_role])
    @dams_role.valueURI = "http://id.loc.gov/vocabulary/relators/"+@dams_role.code.to_s
    @dams_vocabs = DamsVocab.find(:all)
    @dams_vocabs.each do |dams_vocab|
         if dams_vocab.vocabDesc == "Role"
               @dams_role.add_relationship(:has_part,dams_vocab)
               @dams_role.vocabularyId = "info:fedora/"+dams_vocab.pid
         end
    end

    @dams_role.save!
    redirect_to dams_roles_path, :notice=>"Role Added"
  end

  def edit
    @dams_role = DamsRole.find(params[:id])
  end

  
  def update
    @dams_role = DamsRole.find(params[:id])
    respond_to do |format|
    if @dams_role.update_attributes(params[:dams_role])
        format.html { redirect_to edit_dams_role_path(@dams_role), notice: 'Dams Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dams_role.errors, status: :unprocessable_entity }
      end
   end
  end

  def index
    @dams_roles = DamsRole.find(:all)
  end
  
  def destroy
    DamsRole.find(params[:id]).destroy
    redirect_to dams_roles_path, :notice=>"Role is deleted"
  end

  def show
    @dams_role = DamsRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dams_role }
      format.xml  { render xml: @dams_role }
    end
  end

  
end
