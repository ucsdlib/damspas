module DamsLicensesHelper
  def render_license_list 
    #stub license list
    render :partial => "dams_licenses/license_links", :collection => DamsLicense.all, :as => :dams_license
  end

  def current_license
    @license
  end
  private 
end
