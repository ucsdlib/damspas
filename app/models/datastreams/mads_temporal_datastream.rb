class MadsTemporalDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.schemeNode(:in => MADS, :to => 'isMemberOfMADSScheme')
	map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority') 
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  def elementListValue
  	eList = elementList.first    
	eList[0] ?	eList[0].elementValue.first : []	
  end
  def elementListValue=(val)
    if val.class == Array
    	val = val.first
    end
    
  	if elementList[0] == nil
      elementList.build
    end
    #need to use eList.size to know where to insert/update the value
    eList = elementList.first
    temporalElement = MadsDatastream::List::TemporalElement.new(elementList.first.graph)
    temporalElement.elementValue = val
    if(eList[0].class == MadsDatastream::List::TemporalElement)
    	eList[0].elementValue = val
    else
    	eList[0] = temporalElement	
    end
  end     
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Temporal]) if new?
    super
  end
end
