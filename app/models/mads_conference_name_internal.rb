class MadsConferenceNameInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type MADS.ConferenceName
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
    map.authority(:in => DAMS, :to => 'authority')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
