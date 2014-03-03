class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
   include Hydra::Controller::ControllerBehavior 
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
 
  helper_method :current_user
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find(session[:user_id])
    elsif @current_user.nil?
      @current_user = User.anonymous(request.ip)
    end
    @current_user
  end

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
