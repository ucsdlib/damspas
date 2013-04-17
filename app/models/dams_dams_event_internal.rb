class DamsDAMSEventInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.DamsDAMSEvent
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.type(:in => DAMS, :to => 'type')
    map.eventDate(:in => DAMS, :to => 'eventDate')
    map.outcome(:in => DAMS, :to => 'outcome')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
  end
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
