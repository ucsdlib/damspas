class ApplicationController < ActionController::Base
  around_action :anonymous_user

  def anonymous_user
    # check ip for unauthenticated users
    if current_user == nil && self.class != Qa::TermsController
     
      # binding.pry
      anon = User.anonymous(request.remote_ip)
      if anon.to_s != 'public'
        @current_user = anon
        logger.warn "#{self.class.name}: wrapping request in anonymous user session (#{current_user})  from ip #{request.remote_ip} to_s: #{anon.to_s}"
      else
      	logger.info "#{self.class.name}: wrapping request in anonymous user session (#{current_user}) from ip #{request.remote_ip} to_s: #{anon.to_s}"
      end
      begin
        yield
      rescue CanCan::AccessDenied => e
        render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
      rescue ActionController::RoutingError => e
        render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
      rescue Exception => e
        render file: "#{Rails.root}/public/500", formats: [:html], status: 500, layout: false
        logger.warn "Error wrapping anonymous request: #{e}"
        e.backtrace.each do |line|
          logger.warn line
        end
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
  # custom 404 error page
  rescue_from ActionController::RoutingError do |exception|
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
  end
end
