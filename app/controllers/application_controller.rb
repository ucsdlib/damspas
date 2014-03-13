class ApplicationController < ActionController::Base
  around_action :anonymous_user

  def anonymous_user
    # check ip for unauthenticated users
    if current_user == nil
      anon = User.anonymous(request.remote_ip)
      if anon.to_s != 'public'
        @current_user = anon
        logger.warn "#{self.class.name}: wrapping request in anonymous user session (#{current_user}) to_s: #{anon.to_s}"
      end
      begin
        yield
      rescue Exception => e
        logger.warn "Error wrapping anonymous request: #{e.backtrace}"
      ensure
        @current_user = nil
      end
    else
      yield
    end
  end

  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
   include Hydra::Controller::ControllerBehavior 
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  layout 'ucsdlib'

  # Adds a few additional behaviors into the application controller   
# Adds Hydra behaviors into the application controller 

  protect_from_forgery
#  before_filter :authenticate_user!

  # custom 403 error page
  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end
end
