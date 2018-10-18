class AuthMailer < ApplicationMailer
default from: 'dams@ucsd.edu'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.auth_mailer.send_link.subject
  #
  def send_link(user)
    @user = user
    @url = URI.join(root_url, new_user_session_url).to_s + "?auth_token=" + @user.authentication_token + "&email=" + @user.email

    mail to: @user.email, subject: "Login Link Request"
  end
end
