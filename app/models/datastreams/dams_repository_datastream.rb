class DamsRepositoryDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => DAMS, :to => 'repositoryName')
    map.description(:in => DAMS, :to => 'repositoryDescription')
    map.uri(:in => DAMS, :to => 'repositoryURI')
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

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
