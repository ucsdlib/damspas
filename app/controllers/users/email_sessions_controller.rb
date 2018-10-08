class Users::EmailSessionsController < Devise::SessionsController
  def email_new
    self.new
  end

  def create
    super
  end
end
