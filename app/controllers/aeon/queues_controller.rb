class Aeon::QueuesController < ApplicationController
  before_action :set_aeon_queue, only: [:show, :edit, :update, :destroy]

  # GET /aeon/queues
  def index
    @aeon_queues = Aeon::Queue.all
  end

  # GET /aeon/queues/1
  def show
  end

  # GET /aeon/queues/new
  def new
    @aeon_queue = Aeon::Queue.new
  end

  # GET /aeon/queues/1/edit
  def edit
  end

  # POST /aeon/queues
  def create
    @aeon_queue = Aeon::Queue.new(aeon_queue_params)

    if @aeon_queue.save
      redirect_to @aeon_queue, notice: 'Queue was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /aeon/queues/1
  def update
    if @aeon_queue.update(aeon_queue_params)
      redirect_to @aeon_queue, notice: 'Queue was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /aeon/queues/1
  def destroy
    @aeon_queue.destroy
    redirect_to aeon_queues_url, notice: 'Queue was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aeon_queue
      @aeon_queue = Aeon::Queue.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def aeon_queue_params
      params[:aeon_queue]
    end
end
