# frozen_string_literal: true

class AuthMailer < ApplicationMailer
  default from: 'spcoll-request@ucsd.edu'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.auth_mailer.send_link.subject
  #
  def send_link(user)
    @user = user
    @url = new_user_session_url(auth_token: @user.authentication_token, email: @user.email)

    mail to: @user.email, subject: 'Access to UC San Diego SC&A Virtual Reading Room'
  end
end
