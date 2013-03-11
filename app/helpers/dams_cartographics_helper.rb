module DamsCartographicsHelper
  def render_cartographic_list 
    #stub cartographic list
    render :partial => "dams_cartographics/cartographic_list", :collection => DamsCartographic.all, :as => :dams_cartographic
  end

  def current_cartographic
    @cartographic
  end
  private 
end
