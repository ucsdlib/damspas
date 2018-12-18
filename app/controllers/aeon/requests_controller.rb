# frozen_string_literal: true

module Aeon
  class RequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

    def set_to_new
      request = Aeon::Request.new.tap { |r| r.id = params[:id] }
      request.set_to_new
      flash[:alert] = 'Authorization request has been resubmitted'
    rescue # rescue all errors to handle them manually
      flash[:notice] = 'Unable to renew this request'
    ensure
      redirect_to aeon_queue_path(Aeon::Queue::NEW_STATUS)
    end

    def set_to_active
      request = Aeon::Request.new.tap { |r| r.id = params[:id] }
      updated_request = request.get_from_server
      Processors::NewRightsProcessor.new(updated_request).authorize
      flash[:alert] = 'Authorization request set to active'
    rescue # rescue all errors to handle them manually
      flash[:notice] = 'Unable complete request'
    ensure
      redirect_to aeon_queue_path(Aeon::Queue::NEW_STATUS)
    end

    def set_to_expire
      request = Aeon::Request.new.tap { |r| r.id = params[:id] }
      updated_request = request.get_from_server
      Processors::NewRightsProcessor.new(updated_request).revoke
      flash[:alert] = 'Authorization request set to expired'
    rescue # rescue all errors to handle them manually
      flash[:notice] = 'Unable complete request'
    ensure
      redirect_to aeon_queue_path(Aeon::Queue::EXPIRED_STATUS)
    end

    private

      def authorize_user
        raise CanCan::AccessDenied unless can? :create, WorkAuthorization
      end
  end
end
