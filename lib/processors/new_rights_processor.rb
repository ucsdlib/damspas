module Processors
  class NewRightsProcessor
    def initialize(request_attributes)
      @request_attributes = request_attributes
    end

    def process
      puts 'anything good please'
      email = @request_attributes[:email]
      if email
        user = User.where(email: email).first_or_create do |user|
          user.provider = 'auth_link',
          user.uid = SecureRandom::uuid
        end
        user.ensure_authentication_token
        if user.valid?
          user.save!
          AuthMailer.send_link(user).deliver_later
        end
      end
      if user && user.valid?
        puts "you did it!"
      else
        puts "you did not do it!"
      end
    end
  end
end
