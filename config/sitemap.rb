require 'rsolr'

Sitemap::Generator.instance.load( :host => "library.ucsd.edu/dc" ) do

  # static pages
  path :root, priority: 1, change_frequency: 'monthly'
  path :about, change_frequency: 'monthly'
  path :faq, change_frequency: 'monthly'
  path :takedown, change_frequency: 'monthly'

  # resources from solr
  records( "DamsObject", :dams_object )
  records( "DamsAssembledCollection", :dams_collection )
  records( "DamsProvenanceCollection", :dams_collection )
  records( "DamsProvenanceCollectionPart", :dams_collection )
end


def records( record_type, record_path )

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
      puts "#{record_type}: #{response['numFound']}"
      total = response["numFound"]
    end
    done += rows

    # output each record
    @records = response['docs']
    @records.each do |rec|
      id = rec['id']
      lastmod = rec['timestamp']
      puts "  id: #{id}, lastmod: #{lastmod}"
      path record_path, params: { id: id }, priority: 0.9, change_frequency: 'monthly', updated_at: lastmod
    end

    # stop looping if this is the last batch
    if done >= total
      more_records = false
    end
  end
end
