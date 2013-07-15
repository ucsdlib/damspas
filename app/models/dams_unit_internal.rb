class DamsUnitInternal
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    rdf_type DAMS.Unit
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => DAMS, :to => 'unitName')
    map.description(:in => DAMS, :to => 'unitDescription')
    map.uri(:in => DAMS, :to => 'unitURI')
    map.code(:in => DAMS, :to => 'code')
    map.group(:in => DAMS, :to => 'unitGroup')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
