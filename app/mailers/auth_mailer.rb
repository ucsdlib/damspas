class AuthMailer < ApplicationMailer
default from: 'dams@ucsd.edu'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.auth_mailer.send_link.subject
  #
  def send_link(user)
    @user = user
    @url = sprintf(
      "%1$s%2$s%3$s%4$s%5$s",
      new_user_session_url,
      "?auth_token=",
      @user.authentication_token,
      "&email=",
      @user.email)

    mail to: @user.email, subject: "Login Link Request"
  end
end
