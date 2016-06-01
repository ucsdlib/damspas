class RandomController < ApplicationController
  include Blacklight::Catalog
  include Dams::RandomControllerHelper
  
  def index
    q = "title_tesim:* AND read_access_group_ssim:public"
    @obj = random_item(q,random_page(q))
    render json: @obj
  end
  
  def show
    q = "title_tesim:* AND read_access_group_ssim:public"
    @docs = public_items(q)
    render json: @docs
  end  
end
