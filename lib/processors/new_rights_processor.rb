module Processors
  class NewRightsProcessor
    def self.process_new
      queue = Aeon::Queue.find(Aeon::Queue::NEW_STATUS)
      queue.requests.each do |request|
        request.set_to_processing
        Processors::NewRightsProcessor.new(request).process
        request.set_to_active
      end
    end

    def self.revoke_old
      WorkAuthorization.where("updated_at < ?", 1.month.ago).each do |auth|
        params = {work_pid: auth.work_pid, email: auth.user.email, aeon_id: auth.aeon_id}
        request = Processors::NewRightsProcessor.new(params)
        request.revoke
      end
    end

    def initialize(request_attributes)
      @request_attributes = request_attributes
      @work_title = @request_attributes[:itemTitle]
      @work_pid = @request_attributes[:subLocation]
      @email = @request_attributes[:email].present? ? @request_attributes[:email] : @request_attributes[:username]
    end

    def process
      return unless @email.present? && user.valid? && @work_pid.present? && work_obj
      create_work_authorization
      send_email
    end

    def revoke
      return unless user && work_obj
      delete_work_authorization
      expire_request(@work_pid)
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
        AuthMailer.send_link(user).deliver_now
      end

      def expire_request(work_id)
        Aeon::Request.find(@work_pid).set_to_expired
      end
  end
end
