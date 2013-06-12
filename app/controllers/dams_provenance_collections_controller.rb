require 'net/http'
require 'json'

class DamsProvenanceCollectionsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @dams_provenance_collection = DamsProvenanceCollection.find(params[:id])
  end

  def new
    @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
    @dams_units = DamsUnit.all( :order=>"system_create_dtsi asc" )
    @dams_assembled_collections = DamsAssembledCollection.all( :order=>"system_create_dtsi asc" )
    
  
  

  end

  def edit
  @mads_complex_subjects = MadsComplexSubject.all( :order=>"system_create_dtsi asc" )
  end

  def create
    @dams_provenance_collection.attributes = params[:dams_provenance_collection]
    if @dams_provenance_collection.save
        redirect_to @dams_provenance_collection, notice: "ProvenanceCollection has been saved"
    else
      flash[:alert] = "Unable to save provenance_collection"
      render :new
    end
  end

  def update
    @dams_provenance_collection.attributes = params[:dams_provenance_collection]
    if @dams_provenance_collection.save
        redirect_to @dams_provenance_collection, notice: "Successfully updated provenance_collection"
    else
      flash[:alert] = "Unable to save provenance_collection"
      render :edit
    end
  end

  def index
    @units = DamsProvenanceCollection.all( :order=>"system_create_dtsi asc" )
  end


end
