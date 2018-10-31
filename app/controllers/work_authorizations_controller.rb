# frozen_string_literal: true

class WorkAuthorizationsController < ApplicationController
  def index
    @work_authorizations = current_user.work_authorizations.all
    if @work_authorizations.blank? # rubocop:disable GuardClause, IfUnlessModifier
      redirect_to root_url
    end
  end

end
