class DamsAssembledCollectionsController < ApplicationController
  #load_and_authorize_resource
  
  def new
    @dams_assembled_collection = DamsAssembledCollection.new
    @dams_langs = DamsLanguage.find(:all)
  end

  def show
    @dams_langs = DamsLanguage.find(:all)
	@dams_roles = DamsRole.find(:all)
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
    @dams_objects = @dams_assembled_collection.dams_objects
    @dams_object = DamsObject.new
    @dams_object.dams_assembled_collection = @dams_assembled_collection
    languageId = @dams_assembled_collection.relationships(:has_part)
    if(!languageId.nil? && languageId.length > 0)
         @damsL = DamsLanguage.find(languageId.first.slice(12..languageId.first.length-1))
    end
    respond_to do |format|
       format.html # show.html.erb
       format.json {render json: @dams_assembled_collection }
       format.xml {render xml: @dams_assembled_collection}
    end
  end

  def destroy    
    DamsAssembledCollection.destroy(params[:id])
    redirect_to dams_assembled_collections_path
  end

  def edit
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
  end

  def index
    @dams_assembled_collections = DamsAssembledCollection.find(:all)
  end

  def create
    @dams_assembled_collection = DamsAssembledCollection.new(params[:dams_assembled_collection].merge(:edit_users => [current_user.user_key ] ))
  
    language_id = @dams_assembled_collection.language.to_s
    @dams_assembled_collection.language = "info:fedora/"+language_id

    if(!language_id.nil? && language_id.length > 0)
         @damsLang = DamsLanguage.find(language_id)
         if(!@damsLang.nil?)
         	@dams_assembled_collection.add_relationship(:has_part,@damsLang)
    
	end    
    end

  respond_to do |format|     
    if @dams_assembled_collection.save
         format.html {redirect_to dams_assembled_collections_path, notice: 'Dams Collection was successfuly created.'}
         format.json {render json: @dams_assembled_collection, status: :created, location: @dams_assembled_collection}
       else
         format.html {render action: "new"}
         format.json {render json: @dams_assembled_collection.error, status: :unprocessable_entity}
       end
    end
  end

 def update
    @dams_assembled_collection = DamsAssembledCollection.find(params[:id])
    respond_to do |format|
      if @dams_assembled_collection.update_attributes(params[:dams_assembled_collection])
        format.html { redirect_to edit_dams_assembled_collection_path(@dams_assembled_collection), notice: 'Dams Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dams_assembled_collection.errors, status: :unprocessable_entity }
      end
    end

  end
end
