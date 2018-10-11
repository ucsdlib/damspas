class PasswordsController < Devise::PasswordsController
  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_session_path(email: true) if is_navigational_format?
  end
end
