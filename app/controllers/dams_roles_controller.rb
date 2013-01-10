class DamsRolesController < ApplicationController
  before_filter :authenticate_user!, :only=>[:create]

  # create
  def create
    @dams_role = DamsRole.new(params[:dams_role])
    @dams_role.valueURI = "http://id.loc.gov/vocabulary/relators/"+@dams_role.code.to_s
    @dams_vocabs = DamsVocab.find(:all, :sort=>'created_at_sort desc')
    @dams_vocabs.each do |dams_vocab|
         if dams_vocab.vocabDesc == "Role"
               @dams_role.add_relationship(:has_part,dams_vocab)
               @dams_role.vocabularyId = "info:fedora/"+dams_vocab.pid
         end
    end

    @dams_role.save!
    redirect_to dams_objects_path, :notice=>"Role Added"
  end
  
  def update
    dams_role = DamsRole.find(params[:id])
    dams_role.save!
    redirect_to dams_objects_path, :notice=>"Role Updated"

  end

  def index
    @dams_roles = DamsRole.find(:all, :sort=>'created_at_sort desc')
  end
  
  def destroy
    @dams_role = DamsRole.destroy(params[:id])
    redirect_to dams_objects_path, :notice=>"Role is deleted"
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
