class DamsRepositoryDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => DAMS, :to => 'name')
    map.description(:in => DAMS, :to => 'description')
    map.uri(:in => DAMS, :to => 'uri')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Repository]) if new?
    super
  end

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("name", type: :text)] = name
    solr_doc[ActiveFedora::SolrService.solr_name("description", type: :text)] = description
    solr_doc[ActiveFedora::SolrService.solr_name("uri", type: :text)] = uri

    return solr_doc
  end
end
