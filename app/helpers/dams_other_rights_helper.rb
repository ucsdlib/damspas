module DamsOtherRightsHelper
  def render_other_right_list 
    #stub license list
    render :partial => "dams_other_rights/other_right_links", :collection => DamsOtherRight.all, :as => :dams_other_right
  end

  def current_other_right
    @other_right
  end
  private 
end
