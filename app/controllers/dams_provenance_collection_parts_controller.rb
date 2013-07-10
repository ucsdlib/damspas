require 'net/http'
require 'json'

class DamsProvenanceCollectionPartsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_provenance_collection_part = DamsProvenanceCollectionPart.find(params[:id])
  end

  def new
    @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
    @dams_units = DamsUnit.all( :order=>"system_create_dtsi asc" )
    @dams_assembled_collections = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
    @dams_objects = DamsObject.all( :order=>"system_create_dtsi asc" )
    @mads_languages = MadsLanguage.all( :order=>"system_create_dtsi asc" )
    @dams_provenance_collection=DamsProvenanceCollection.all( :order=>"system_create_dtsi asc" )
  end

  def edit
    @dams_provenance_collection = DamsProvenanceCollection.find(params[:id])
    @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
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
