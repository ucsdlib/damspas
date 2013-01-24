class DamsPersonDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
 end

  rdf_subject { |ds| RDF::URI.new("http://library.ucsd.edu/ark:/20775/#{ds.pid}")}

  after_initialize :type_resource
  def type_resource
    graph.insert([rdf_subject, RDF.type, MADS.PersonalName])
  end

end

