class MadsTopicInternal
  include ActiveFedora::RdfObject
  include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type MADS.Topic
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end 
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
