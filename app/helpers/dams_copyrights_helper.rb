module DamsCopyrightsHelper
  def render_copyright_list 
    #stub copyright list
    render :partial => "dams_copyrights/copyright_links", :collection => DamsCopyright.all, :as => :dams_copyright
  end

  def current_copyright
    @copyright
  end
  private 
end
