class DamsUnitsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @unit = DamsUnit.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_unit.attributes = params[:dams_unit]
    if @dams_unit.save
        redirect_to @dams_unit, notice: "Unit has been saved"
    else
      flash[:alert] = "Unable to save unit"
      render :new
    end
  end

  def update
    @dams_unit.attributes = params[:dams_unit]
    if @dams_unit.save
        redirect_to @dams_unit, notice: "Successfully updated unit"
    else
      flash[:alert] = "Unable to save unit"
      render :edit
    end
  end

  def index
    @units = DamsUnit.all( :order=>"system_create_dtsi asc" )
  end


end
