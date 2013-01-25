class DamsRepositoriesController < ApplicationController
  def index
  end

  def show
    @repository = DamsRepository.find(params[:id])
  end

end
