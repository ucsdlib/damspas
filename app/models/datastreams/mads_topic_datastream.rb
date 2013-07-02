class MadsTopicDatastream < MadsDatastream
  include DamsHelper
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.schemeNode(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Topic]) if new?
    super
  end
  
  def elementValue
    getElementValue "TopicElement"
  end
  
  def elementValue=(s)
    setElementValue( "TopicElement", s )
  end
  
#  def to_solr (solr_doc = {})
#    super
#  end
end
