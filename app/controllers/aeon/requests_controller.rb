class Aeon::RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_aeon_queue, only: [:show, :edit, :update, :destroy]

  def set_to_expire
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    request.set_to_expired
    redirect_to aeon_queue_path(Aeon::Queue::EXPIRED_STATUS)
  end

  def set_to_complete
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    request.set_to_completed
    redirect_to aeon_queue_path(Aeon::Queue::PROCESSING_STATUS)
  end

  def set_to_in_process
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    updated_request = request.get_from_server
    Processors::NewRightsProcessor.new(updated_request).authorize
    redirect_to aeon_queue_path(Aeon::Queue::NEW_STATUS)
  end

  def set_to_expire
    request = Aeon::Request.new.tap{|r| r.id = params[:id]}
    updated_request = request.get_from_server
    Processors::NewRightsProcessor.new(updated_request).revoke
    redirect_to aeon_queue_path(Aeon::Queue::EXPIRED_STATUS)
  end

  private
    def authorize_user
      raise CanCan::AccessDenied unless can? :create, WorkAuthorization 
    end
end