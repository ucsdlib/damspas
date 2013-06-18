class DamsScientificNameInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.ScientificName
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end 
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
