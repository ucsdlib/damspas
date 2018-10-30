module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
      @work_pid = @request_attributes[:work_pid]
    end

    def process
      puts 'begin task'
      return unless @request_attributes[:email].present? && user.valid? && @work_pid.present? && work_obj
      create_work_authorization
      send_email
    end

    private

      def user
        return @user if @user
        @user = User.where(email: @request_attributes[:email]).first_or_initialize do |user| # only hits the do on initialize
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

      def create_work_authorization
        if user.work_authorizations.create(work_title: work_obj.titleValue)
          work_obj.read_users = [user.user_key]
          work_obj.save
        end
      end

      def send_email
        AuthMailer.send_link(user).deliver_later
      end
  end
end
