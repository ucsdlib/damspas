class MadsLanguageDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.code(:in => MADS)
    map.schemeNode(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Language]) if new?
    super
  end
  def elementValue
    getElementValue "LanguageElement"
  end
  def elementValue=(s)
    setElementValue( "LanguageElement", s )
  end
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'code', code.first)
    super
  end
end
