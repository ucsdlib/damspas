# frozen_string_literal: true

module Processors
  class NewRightsProcessor
    class UserError < RuntimeError; end
    class WorkError < RuntimeError; end

    def self.process_new
      queue = Aeon::Queue.find(Aeon::Queue::NEW_STATUS)
      queue.requests.each do |request|
        begin
          Rails.logger.debug("*** started processing #{request.id}")
          request.set_to_processing
          Processors::NewRightsProcessor.new(request).authorize
          request.set_to_active
        rescue => e
          Rails.logger.error "Work auth failed for reason #{e.message}\n #{e.backtrace}"
        end
      end
    end

    def self.revoke_old
      WorkAuthorization.where('updated_at < ?', 1.month.ago).each do |auth|
        begin
          params = { work_pid: auth.work_pid, email: auth.user.email, aeon_id: auth.aeon_id }
          request = Processors::NewRightsProcessor.new(params)
          request.revoke
        rescue => e
          Rails.logger.error "Revoke on #{auth.id} failed #{e.message}\n#{e.backtrace}"
        end
      end
    end

    def initialize(request_attributes)
      @request_attributes = request_attributes
      @work_title = @request_attributes[:itemTitle]
      @work_pid = if ['development'].include? Rails.env
                    DamsObject.last.pid
                  else
                    @request_attributes[:subLocation]
                  end
      @email = @request_attributes[:email].presence || @request_attributes[:username]
      Rails.logger.debug("*** created processor #{@work_title} - #{@work_pid} - #{@email}")
    end

    def authorize
      raise NewRightsProcessor::UserError, 'email missing' if @email.blank?
      raise NewRightsProcessor::UserError, 'user invalid' if !user.valid? || user.new_record?
      raise NewRightsProcessor::WorkError, 'work pid missing' if @work_pid.blank?
      raise NewRightsProcessor::WorkError, 'work object missing' if work_obj.blank?
      process_request(@request_attributes.id)
      create_work_authorization
      activate_request(@request_attributes.id)
      Rails.logger.debug("*** request activated #{@request_attributes.id}")
      send_email
      Rails.logger.debug("*** email sent #{@request_attributes.id}")
    rescue NewRightsProcessor::UserError => e
      work_authorization(false).update_error e.message
      raise e
    rescue => e # rescue all errors to handle them manually
      work_authorization.update_error e.message
      raise e
    end

    def revoke
      return unless user && work_obj
      delete_work_authorization
      expire_request(@request_attributes.id)
    rescue => e # rescue all errors to handle them manually
      work_authorization.update_error 'Unable to Revoke Request'
      raise e
    end

    private

      def user
        return @user if @user
        @user = User.where(email: @email).first_or_create do |user| # only hits the do on initialize
          user.provider = 'auth_link'
          user.uid = SecureRandom.uuid
          user.ensure_authentication_token
        end
      end

      def work_obj
        return @work_obj if @work_obj
        @work_obj = DamsObject.where(pid: @work_pid).first if @work_pid
      end

      def work_authorization(with_user = true)
        if with_user
          @work_authorization ||= user.work_authorizations.where(work_pid: @work_pid).first_or_create do |authorization|
            authorization.aeon_id = @request_attributes.id
            authorization.work_title = @work_title
          end
        else
          WorkAuthorization.where(work_pid: @work_pid).first_or_create do |authorization|
            authorization.aeon_id = @request_attributes.try(:id)
            authorization.work_title = @work_title
          end
        end
      end

      def create_work_authorization
        return unless work_authorization.valid?
        # touch to get the updated authorizations
        # disable rubocop because we run validations before calling .touch
        work_authorization.clear_error
        work_authorization.touch # rubocop:disable SkipsModelValidations
        work_obj.set_read_users([user.user_key], [user.user_key])
        work_obj.save
      end

      def delete_work_authorization
        work_authorization.destroy
        work_obj.set_read_users([], [user.user_key])
        work_obj.save
      end

      def send_email
        AuthMailer.send_link(user).deliver_later
      end

      def process_request(request_id)
        Aeon::Request.find(request_id).set_to_processing
      end

      def expire_request(request_id)
        Aeon::Request.find(request_id).set_to_expired
      end

      def activate_request(request_id)
        Aeon::Request.find(request_id).set_to_active
      end
  end
end
