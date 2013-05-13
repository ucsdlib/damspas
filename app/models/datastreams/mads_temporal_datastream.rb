class MadsTemporalDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
    map.authority(:in => DAMS, :to => 'authority')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  def elementListValue
  	eList = elementList.first    
	eList[0] ?	eList[0].elementValue.first : []
  end
  def elementListValue=(val)
  	if elementList[0] == nil
      elementList.build
    end
    puts elementList[0]
    puts elementList[0].first.to_s
    elementList[0].first.elementValue = val
  end     
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Temporal]) if new?
    super
  end
end
