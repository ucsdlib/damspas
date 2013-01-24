module DamsRepositoriesHelper
  def render_repository_list 
    #stub repository list
    render :partial => "dams_repositories/repository_links", :collection => DamsRepository.all, :as => :dams_repository
  end
  private 
end
