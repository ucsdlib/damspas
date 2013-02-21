module DamsSourceCapturesHelper
  def render_source_capture_list 
    #stub SourceCapture list
    render :partial => "dams_source_captures/source_capture_links", :collection => DamsSourceCapture.all, :as => :dams_source_capture
  end

  def current_source_capture
    @source_capture
  end
  private 
end
