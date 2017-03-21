class RandomController < ApplicationController
  include Blacklight::Catalog
  include Dams::RandomControllerHelper
  
  def index
    q = "title_tesim^99"
    fq = "read_access_group_ssim:public"
    @obj = random_item(q, fq, random_page(q, fq))
    render json: @obj
  end 
end
