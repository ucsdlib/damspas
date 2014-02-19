Sitemap::Generator.instance.load( :host => "library.ucsd.edu/dc" ) do

  path :root, priority: 1, change_frequency: 'monthly'
  path :about, change_frequency: 'monthly'
  path :faq, change_frequency: 'monthly'
  path :takedown, change_frequency: 'monthly'

  read_group = Solrizer.solr_name('read_access_group', :symbol)
  DamsObject.where(read_group => 'public').all.each do |obj|
    path :dams_object, params: { id: obj.pid }, priority: 0.9, change_frequency: 'monthly', updated_at: obj.modified_date
  end
  DamsAssembledCollection.where(read_group => 'public').all.each do |col|
    path :dams_collection, params: { id: col.pid }, priority: 0.9, change_frequency: 'monthly', updated_at: col.modified_date
  end
  DamsProvenanceCollection.where(read_group => 'public').all.each do |col|
    path :dams_collection, params: { id: col.pid }, priority: 0.9, change_frequency: 'monthly', updated_at: col.modified_date
  end
  DamsProvenanceCollectionPart.where(read_group => 'public').all.each do |col|
    path :dams_collection, params: { id: col.pid }, priority: 0.9, change_frequency: 'monthly', updated_at: col.modified_date
  end
end
