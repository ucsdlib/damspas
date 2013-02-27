class MadsCorporateNameDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
    map.authority(:in => DAMS, :to => 'authority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.CorporateName]) if new?
    super
  end
end
