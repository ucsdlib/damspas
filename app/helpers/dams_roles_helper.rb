module DamsRolesHelper
  def render_role_list 
    #stub role list
    render :partial => "dams_roles/role_links", :collection => DamsRole.all, :as => :dams_role
  end

  def current_role
    @role
  end
  private 
end
