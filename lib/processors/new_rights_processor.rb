module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
      @work_title = @request_attributes[:itemTitle]
      @work_pid = @request_attributes[:work_pid]
      @email = @request_attributes[:email]
    end

    def process
      return unless @email.present? && user.valid? && @work_pid.present? && work_obj
      create_work_authorization
      send_email
    end

    def revoke
      return unless user && work_obj
      delete_work_authorization
      expire_request
    end

    private

      def user
        return @user if @user
        @user = User.where(email: @email).first_or_initialize do |user| # only hits the do on initialize
                user.provider = 'auth_link'
                user.uid = SecureRandom::uuid
                user.ensure_authentication_token
        end
        @user.save
        @user
      end

      def work_obj
        return @work_obj if @work_obj
        @work_obj = DamsObject.where(pid: @work_pid).first if @work_pid
      end

      def work_authorization
        # TODO:  using work_pid, which isn't on an aeon request
        @work_auth ||= user.work_authorizations.where(work_pid: @work_pid).first_or_create do |authorization|
          authorization.work_title = @work_title
        end
      end

      def create_work_authorization
        if work_authorization.valid?
          work_authorization.touch # for updated authorizations
          new_list = work_obj.read_users + [user.user_key]
          work_obj.read_users = new_list.uniq
          work_obj.save
        end
      end

      def delete_work_authorization
        work_authorization.destroy
        new_list = work_obj.read_users - [user.user_key]
        work_obj.read_users = new_list.uniq
        work_obj.save
      end

      def send_email
        AuthMailer.send_link(user).deliver_later
      end

      def expire_request
        Aeon::Request.set_to_expired
      end
  end
end
