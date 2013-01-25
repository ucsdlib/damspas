class DamsPersonDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.PersonalName]) if new?
    super
  end

end

