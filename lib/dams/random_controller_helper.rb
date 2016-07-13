module Dams
  module RandomControllerHelper
    # Retrieve random page from solr index
    def random_page(q, fq)
      @response, @document = get_search_results(:qf => "#{q}", :fq => "#{fq}", :rows => 100)
      page_count = @response.response['numFound']/100.to_f
      pages = Array.new    
      for i in 1..page_count.ceil
        pages << "#{i}"
      end    
	  pages.sample	
    end
    
    # Retrieve random item from solr index
    def random_item(q, fq, page)
      @response, @document = get_search_results(:qf => "#{q}", :fq => "#{fq}", :rows => 100, :page => "#{page}")
      doc = @document.sample if @document
      if(doc['has_model_ssim'].to_s.include? "Collection")
        "#{root_url}collection/#{doc['id']}"
      else
        "#{root_url}object/#{doc['id']}"
      end
    end
        
  end
end