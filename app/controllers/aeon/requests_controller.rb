class Aeon::RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_aeon_queue, only: [:show, :edit, :update, :destroy]

  def set_to_new
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    request.set_to_new
    flash[:alert] = "Authorization request has been resubmitted."
  rescue
    flash[:notice] = "Unable to renew this request"
  ensure
    redirect_to aeon_queue_path(Aeon::Queue::NEW_STATUS)
  end

  def set_to_active
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    updated_request = request.get_from_server
    Processors::NewRightsProcessor.new(updated_request).authorize
    flash[:alert] = "Authorization request set to active"
  rescue
    flash[:notice] = "Unable complete request "
  ensure
     redirect_to aeon_queue_path(Aeon::Queue::NEW_STATUS)
  end

  def set_to_expire
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    updated_request = request.get_from_server
    Processors::NewRightsProcessor.new(updated_request).revoke
    flash[:alert] = "Authorization request set to expired."
  rescue
    flash[:notice] = "Unable complete request."
  ensure
    redirect_to aeon_queue_path(Aeon::Queue::EXPIRED_STATUS)
  end

  private
    def authorize_user
      raise CanCan::AccessDenied unless can? :create, WorkAuthorization 
    end

end
