module MadsPersonalNamesHelper
  def render_personal_name_list
    render :partial => "mads_personal_names/personal_name_links", :collection => MadsPersonalName.all, :as => :mads_personal_name
  end

  def current_personal_name
    @personal_name
  end
  private 
end
