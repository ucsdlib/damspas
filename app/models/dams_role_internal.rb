class DamsRoleInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.Role
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.code(:in => DAMS, :to => 'code')
    map.value(:in => RDF, :to => 'value')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.vocab(:in => DAMS, :to => 'vocabulary')
  end
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
