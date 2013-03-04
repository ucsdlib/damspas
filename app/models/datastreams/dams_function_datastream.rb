class DamsFunctionDatastream < DamsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.authority(:in => DAMS, :to => 'authority')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
    
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Function]) if new?
    super
  end
    
end
