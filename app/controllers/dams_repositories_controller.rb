class DamsRepositoriesController < ApplicationController
  def index
  end

  def show
    @repository = DamsRepository.all.select { |x| x.id == params[:id]}.first

    if @repository.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
