class MadsSchemeInternal
  include ActiveFedora::RdfObject
  include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type MADS.MADSScheme
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: RDF::RDFS, to: "label" )
  end 
  # This is never called
  #rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  
  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end

end
