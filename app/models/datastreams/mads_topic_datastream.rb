class MadsTopicDatastream < ActiveFedora::RdfxmlRDFDatastream
  include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.Topic
  map_predicates do |map|
    map.label(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'MadsNestedElementList')
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Topic]) if new?
    super
  end

  accepts_nested_attributes_for :elementList, :scheme

  class MadsNestedElementList
    include ActiveFedora::RdfList
    map_predicates do |map|
      map.topicElement(:in=> MADS, :to =>"TopicElement", :class_name => "MadsTopicElement")
    end
    accepts_nested_attributes_for :topicElement
  end
  class MadsTopicElement
    include ActiveFedora::RdfObject
    rdf_type MADS.TopicElement
    map_predicates do |map|
      map.elementValue(:in=> MADS)
    end
  end
  def to_solr (solr_doc = {})
    super
  end
end
