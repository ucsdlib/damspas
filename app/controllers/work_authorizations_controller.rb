class WorkAuthorizationsController < ApplicationController
  def index
    @work_authorizations = current_user.work_authorizations.all
    if @work_authorizations.blank?
      redirect_to root_url
    end
  end
end
