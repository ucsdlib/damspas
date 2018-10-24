class WorkAuthorizationsController < ApplicationController
  def index
    @work_authorizations = current_user.work_authorizations.all
  end
end
