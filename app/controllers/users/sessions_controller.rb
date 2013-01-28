class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to user_omniauth_authorize_path(Devise.omniauth_configs.keys.first)
  end
end
