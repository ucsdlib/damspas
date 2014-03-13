class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to user_omniauth_authorize_path(Devise.omniauth_configs.keys.first)
  end

  

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:alert] = ('You have been logged out of Digital Collections. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'"><u>terminate your Shibboleth session</u></a>.').html_safe if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

 end
