class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def developer
    find_or_create_user('developer')
  end
  def shibboleth
    find_or_create_user('shibboleth')
  end

  def find_or_create_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
    logger.debug "#{auth_type} :: #{current_user.inspect}"
  	@user = User.send(find_or_create_method,request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => auth_type
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.#{auth_type.downcase}_data"] = request.env["omniauth.auth"]
      redirect_to root_url #Have this redirect someplace better like IU CAS guest account creation page
    end
  end
  protected :find_or_create_user
end
