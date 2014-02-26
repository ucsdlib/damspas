class PagesController < ApplicationController
  #before_action :set_page, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:show, :edit, :update, :destroy]
  authorize_resource only: [:new, :create]

  # ------------------------
  # public methods (no auth)
  # ------------------------

  # GET /pages
  def index
    @pages = Page.all
  end

  # GET /pages/code/view
  def view
    @page = Page.find_by code: params[:id]
  end

  # ---------------
  # controller auth
  # ---------------

  # GET /pages/new
  def new
    @page = Page.new
  end

  # POST /pages
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to pages_url, notice: 'Page was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /pages/1
  def show
  end

  # GET /pages/1/edit
  def edit
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      redirect_to edit_page_path(@page), notice: 'Page successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:code, :title, :body)
    end
end
