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
end
