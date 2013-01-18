class DamsObjectsController < ApplicationController
  #load_and_authorize_resource
  before_filter :authenticate_user!, :only=>[:create] 
 
  def new
    @dams_object = DamsObject.new
    @dams_langs = DamsLanguage.find(:all)
    @dams_language = DamsLanguage.new
    @dams_roles = DamsRole.find(:all)
    @dams_role = DamsRole.new
	@dams_assembled_collections = DamsAssembledCollection.find(:all)
  end

  def show
    @dams_object = DamsObject.find(params[:id])
#    @dams_langs = DamsLanguage.find(:all)
#    @dams_languages = @dams_object.dams_languages
#    @dams_language = DamsLanguage.new
#    @dams_language.dams_object = @dams_object
   # @damsL = DamsLanguage.find("changeme:2")
    languageId = @dams_object.relationships(:has_part)
    if(!languageId.nil? && languageId.length > 0)
         @damsL = DamsLanguage.find(languageId.first.slice(12..languageId.first.length-1))
    end

    roleId = @dams_object.relationships(:has_metadata)
    if(!roleId.nil? && roleId.length > 0)
         @damsR = DamsRole.find(roleId.first.slice(12..roleId.first.length-1))
    end

    respond_to do |format|
       format.html # show.html.erb
       format.json {render json: @dams_object }
       format.xml {render xml: @dams_object}
    end
  end

  def destroy    
    DamsObject.destroy(params[:id])
    redirect_to dams_objects_path
  end

  def edit
    @dams_object = DamsObject.find(params[:id])
  end

  def index
    @dams_objects = DamsObject.find(:all)
  end

  def create
    dams_assembled_collection_id = params[:dams_object].delete(:dams_assembled_collection_id)
    @dams_object = DamsObject.new(params[:dams_object].merge(:edit_users => [current_user.user_key ] ))
    if(dams_assembled_collection_id.nil?)
    	dams_assembled_collection_id = @dams_object.assembledCollection
    end
    
    @dams_object.arkUrl = "http://library.ucsd.edu/ark:/20775/"+@dams_object.object_id.to_s
    #dams_assembled_collection_id = params[:dams_object].delete(:dams_assembled_collection_id)
    @dams_object.dams_assembled_collection_id = dams_assembled_collection_id 
    #damsL = DamsLanguage.find("changeme:2")
    #@dams_object.add_relationship(:has_part,damsL)
    language_id = @dams_object.languageId.to_s
    @dams_object.languageId = "info:fedora/"+language_id

    if(!language_id.nil? && language_id.length > 0)
         @damsLang = DamsLanguage.find(language_id)
         if(!@damsLang.nil?)
         	@dams_object.add_relationship(:has_part,@damsLang)
    
		end    
    end

    role_id = @dams_object.relationshipRole.to_s
    @dams_object.relationshipRole = "info:fedora/"+role_id

    if(!role_id.nil? && role_id.length > 0)
         @damsRole = DamsRole.find(role_id)
         if(!@damsRole.nil?)
                @dams_object.add_relationship(:has_metadata,@damsRole)

        end
    end

    respond_to do |format|
       if @dams_object.save
         format.html {redirect_to dams_objects_path, notice: 'Dams Object was successfuly created.'}
         format.json {render json: @dams_object, status: :created, location: @dams_object}
       else
         format.html {render action: "new"}
         format.json {render json: @dams_object.error, status: :unprocessable_entity}
       end
    end
     #@dams_object.save!
     #redirect_to dams_objects_path, :notice=>"Added Dams Object"
  end

 def update
    @dams_object = DamsObject.find(params[:id])
    #@dams_object.update_attributes(params[:dams_object])
    @dams_object.arkUrl = "http://library.ucsd.edu/ark:/20775/"+ @dams_object.object_id.to_s
#redirect_to :edit
    respond_to do |format|
      if @dams_object.update_attributes(params[:dams_object])
        format.html { redirect_to edit_dams_object_path(@dams_object), notice: 'Dams Object was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dams_object.errors, status: :unprocessable_entity }
      end
    end

  end

end
