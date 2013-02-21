module DamsPersonalNamesHelper
  def render_personal_name_list 
    render :partial => "dams_personal_names/personal_name_links", :collection => DamsPersonalName.all, :as => :dams_personal_name
  end

  def current_personal_name
    @personal_name
  end
  private 
end
