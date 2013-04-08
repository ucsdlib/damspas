class DamsCulturalContextInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.CulturalContext
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.authority(:in => DAMS, :to => 'authority')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end 
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
