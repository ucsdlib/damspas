module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
    end

    def process
      puts 'begin task'
      email = @request_attributes[:email]
      work_title = @request_attributes[:work_title]
      if email.present? # User.email defaults to blank string; won't create a user with a blank email
        @user = User.where(email: email).first_or_initialize do |user| # only hits the do on initialize
          user.provider = 'auth_link'
          user.uid = SecureRandom::uuid
          user.ensure_authentication_token
          puts 'new user created'
        end
        if @user.valid?
          @user.save!
          @user.work_authorizations.create(work_title: work_title)
          puts 'work authorized'
          AuthMailer.send_link(@user).deliver_later
          puts 'email sent!'
        end
      elsif email == ''
        puts 'email cannot be blank'
      end
      if @user && @user.valid?
        puts '>>>>>> Task succeeded!'
      else
        puts '>>>>>> TASK FAILED'
      end
    end
  end
end
