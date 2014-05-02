class AuditsController < ApplicationController
  before_action :set_audit, only: [:show]
  before_action :authorize

  # GET /audits
  def index
    @audits = Audit.all
  end

  # GET /audits/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audit
      @audit = Audit.find(params[:id])
    end

    def authorize
      authorize! :show, Audit
    end

    # Only allow a trusted parameter "white list" through.
    def audit_params
      params.require(:audit).permit(:user, :action, :classname, :object)
    end
end
