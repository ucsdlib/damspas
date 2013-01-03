class DamsLanguagesController < ApplicationController
  before_filter :authenticate_user!, :only=>[:create]

  # create
  def create
#    dams_object_id = params[:dams_language].delete(:dams_object_id)
    @dams_language = DamsLanguage.new(params[:dams_language])
#    @dams_language.dams_object_id = dams_object_id
    @dams_language.valueURI = "http://id.loc.gov/vocabulary/iso639-1/"+@dams_language.code.to_s
    @dams_language.save!
#   redirect_to dams_object_path(@dams_language.dams_object), :notice=>"Language Added"
    redirect_to dams_objects_path, :notice=>"Language Added"
  end
  
  def update
    dams_language = DamsLanguage.find(params[:id])
    dams_language.save!
#    redirect_to dams_object_path(dams_language.dams_object), :notice=>"Language Updated"
    redirect_to dams_objects_path, :notice=>"Language Updated"

  end

  def index
    @dams_languages = DamsLanguage.find(:all, :sort=>'created_at_sort desc')
  end
  
  def destroy
    @dams_language = DamsLanguage.destroy(params[:id])
    redirect_to dams_languages_path, :notice=>"Language is deleted"
  end

  def show
    @dams_language = DamsLanguage.find(params[:id])
 #   @dams_object = @dams_language.dams_object

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dams_language }
      format.xml  { render xml: @language }
    end
  end

  
end
