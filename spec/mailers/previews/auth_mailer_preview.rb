# Preview all emails at http://localhost:3000/rails/mailers/auth_mailer
class AuthMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/auth_mailer/send_link
  def send_link
    AuthMailer.send_link
  end

end
