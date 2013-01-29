module DamsStatutesHelper
  def render_statute_list 
    #stub statute list
    render :partial => "dams_statutes/statute_links", :collection => DamsStatute.all, :as => :dams_statute
  end

  def current_statute
    @statute
  end
  private 
end
