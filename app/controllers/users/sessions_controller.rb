class Users::SessionsController < Devise::SessionsController
  # TODO: Potentially add a validation here to detect where the user
  # arrives, whether they are a omniauth user or a email user
  def new
    if params[:auth_token] && params[:email]
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

  def new_auth_link
    render 'devise/auth_link/new.html.erb'
  end

  def create_auth_link
    @email = params[:user][:email]
    @user = User.where(email: @email).first
    if @user.present? && !@user.authentication_token.nil?
      AuthMailer.send_link(@user).deliver_later
      redirect_to root_path, notice: 'Email sent successfully! Check your inbox for the link.'
    else
      redirect_to new_auth_link_path, alert: "User doesn't exist."
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
        redirect_to work_authorizations_path, notice: 'Successfully authenticated from email account.'
        sign_in user
      else
        redirect_to root_path, alert: 'Authentication failed: Your credentials were invalid.'
      end
    end
end

