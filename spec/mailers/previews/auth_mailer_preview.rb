# Preview all emails at http://localhost:3000/rails/mailers/auth_mailer
class AuthMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/auth_mailer/send_link
  def send_link
    user_attributes = {
      email: 'test@example.com',
      provider: 'email',
      uid: SecureRandom.uuid,
      authentication_token: 'secret'
    }
    user = User.new(user_attributes)
    AuthMailer.send_link(user)
  end
end
