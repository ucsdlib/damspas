class DamsEventInternal < ActiveFedora::Rdf::Resource
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    rdf_type DAMS.DAMSEvent
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }

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
