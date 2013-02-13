class DamsProvenanceCollectionPartsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_provenance_collection_part = DamsProvenanceCollectionPart.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_provenance_collection_part.attributes = params[:dams_provenance_collection_part]
    if @dams_provenance_collection_part.save
        redirect_to @dams_provenance_collection_part, notice: "ProvenanceCollectionPart has been saved"
    else
      flash[:alert] = "Unable to save provenance_collection_part"
      render :new
    end
  end

  def update
    @dams_provenance_collection_part.attributes = params[:dams_provenance_collection_part]
    if @dams_provenance_collection_part.save
        redirect_to @dams_provenance_collection_part, notice: "Successfully updated provenance_collection_part"
    else
      flash[:alert] = "Unable to save provenance_collection_part"
      render :edit
    end
  end

  def index
    @dams_provenance_collection_parts = DamsProvenanceCollectionPart.all( :order=>"system_create_dtsi asc" )
  end


end
