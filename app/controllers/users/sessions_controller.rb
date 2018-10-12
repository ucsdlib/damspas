class Users::SessionsController < Devise::SessionsController
  def new
    if params[:auth_token]
      authenticate_user_from_token!
    else
      redirect_to user_omniauth_authorize_path(Devise.omniauth_configs.keys.first)
    end
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:alert] = ('You have been logged out of Digital Collections. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'">terminate your Shibboleth session</a>.').html_safe if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  def new_invite
    render 'devise/invites/new.html.erb'
  end

  def create_invite
    if params[:user][:email] != ''
      @user = User.new(
        email: params[:user][:email],
        provider: 'invited',
        uid: SecureRandom::uuid
      )
      @user.ensure_authentication_token
      @user.save!
      redirect_to root_path, notice: 'user_invited'
    else
      redirect_to new_invite_path, alert: 'Please enter a valid email address'
    end
  end

  private

  def authenticate_user_from_token!
    user_email = params[:email].presence
    user       = user_email && User.find_by_email(user_email)
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
      redirect_to root_path, notice: 'signed_in'
      sign_in user
    else
      redirect_to root_path, alert: 'invalid_token'
    end
  end
 end
