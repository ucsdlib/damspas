class DamsLicensesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :index

  def show
    @license = DamsLicense.find(params[:id])
  end

  def new

  end

  def edit

  end

  def create
    @dams_license.attributes = params[:dams_license]
    if @dams_license.save
        redirect_to @dams_license, notice: "Licenses has been saved"
    else
      flash[:alert] = "Unable to save license"
      render :new
    end
  end

  def update
    @dams_license.attributes = params[:dams_license]
    if @dams_license.save
        redirect_to @dams_license, notice: "Successfully updated license"
    else
      flash[:alert] = "Unable to save license"
      render :edit
    end
  end

  def index
    @licenses = DamsLicense.all
  end

end
