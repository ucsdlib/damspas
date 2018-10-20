module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
    end

    def process
      puts 'begin task'
      email = @request_attributes[:email]
      if email
        user = User.where(email: email).first_or_initialize do |user| # only hits the do on initialize
          user.provider = 'auth_link',
          user.uid = SecureRandom::uuid
          user.provider = JSON.parse(user.provider)[0] # Line 12 sets user.provider to a hash containing the values of both provider and the uid for a currently unknown reason
          user.ensure_authentication_token
        end
        if user.valid?
          user.save!
          AuthMailer.send_link(user).deliver_later
          puts "email sent!"
        end
      end
      if user && user.valid?
        puts ">>>>>> Task succeeded!"
      else
        puts ">>>>>> TASK FAILED"
      end
    end
  end
end
