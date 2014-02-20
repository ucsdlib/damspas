# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://library.ucsd.edu/dc"
SitemapGenerator::Sitemap.compress = :all_but_first

SitemapGenerator::Sitemap.create do

  # static pages
  add '/about'
  add '/faq'
  add '/takedown'

  # resources from solr
  resources = {
    :DamsObject => :object,
    :DamsAssembledCollection => :dams_collections,
    :DamsProvenanceCollection => :dams_collections,
    :DamsProvenanceCollectionPart => :dams_collections
  }
  resources.each do |record_type,record_path|
    rows = 100
    done = 0
    total = 0
    more_records = true
    solr = RSolr.connect( :url => ActiveFedora.solr_config[:url] )
    while ( more_records )
      # get a batch of records from solr
      solr_response = solr.get 'select', :params => {:q => "has_model_ssim:\"info:fedora/afmodel:#{record_type}\" AND read_access_group_ssim:public", :rows => rows, :wt => :ruby, :start => done}
      response = solr_response['response']
      if done == 0
        if SitemapGenerator::Sitemap.verbose
          puts "#{record_type}: #{response['numFound']} records"
        end
        total = response["numFound"]
      end
      done += rows
  
      # output each record
      @records = response['docs']
      @records.each do |rec|
        id = rec['id']
        lastmod = rec['timestamp']
        if SitemapGenerator::Sitemap.verbose
          puts "#{record_type}: #{id}, lastmod: #{lastmod}"
        end
        add "#{record_path}/#{id}", priority: 0.9, :changefreq => 'monthly', :lastmod => lastmod
      end
  
      # stop looping if this is the last batch
      if done >= total
        more_records = false
      end
    end
  end

end
