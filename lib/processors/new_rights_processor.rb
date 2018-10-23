module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
    end

    def process
      puts 'begin task'
      email = @request_attributes[:email]
      if email
        @user = User.where(email: email).first_or_initialize do |user| # only hits the do on initialize
          user.provider = 'auth_link'
          user.uid = SecureRandom::uuid
          user.ensure_authentication_token
          puts 'new user created'
        end
        if @user.valid?
          @user.save!
          AuthMailer.send_link(@user).deliver_later
          puts "email sent!"
        end
      end
      if @user && @user.valid?
        puts ">>>>>> Task succeeded!"
      else
        puts ">>>>>> TASK FAILED"
      end
    end
  end
end
