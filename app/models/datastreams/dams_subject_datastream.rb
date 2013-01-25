class DamsSubjectDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.label(:in => MADS, :to => 'authoritativeLabel')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}


  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
    super
  end
end
