class AuthMailer < ApplicationMailer
default from: 'ucsd@example.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.auth_mailer.send_link.subject
  #
  def send_link(user)
    @user = user
    mail to: @user.email, subject: "Login Link Request"
  end
end
