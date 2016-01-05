module Dams
  module RandomControllerHelper
    # Retrieve random page from solr index
    def random_page(q)
      @response, @document = get_search_results(:q => "#{q}", :rows => 1)
      page_count = @response.response['numFound']/20.to_f   
      pages = Array.new    
      for i in 1..page_count.ceil
        pages << "#{i}"
      end    
	  pages.sample	
    end
    
    # Retrieve random item from solr index
    def random_item(q, page)
      @response, @document = get_search_results(:q => "#{q}", :rows => 20, :page => "#{page}")
      doc = @document.sample if @document
      if(doc['has_model_ssim'].to_s.include? "Collection")
        "#{root_url}collection/#{doc['id']}"
      else
        "#{root_url}object/#{doc['id']}"
      end
    end
    
    # Retrieve 100 public access items from solr index
    def public_items(q)
      @response, @document = get_search_results(:q => "#{q}", :rows => 100)
      docs = Array.new
      @document.each do |doc|    
        docs << "#{doc['id']}"
      end
      docs
    end         
  end
end
