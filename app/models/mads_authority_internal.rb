class MadsAuthorityInternal < ActiveFedora::Rdf::Resource
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    rdf_type MADS.Authority
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: MADS, to: "authoritativeLabel" )
    map.description( in: MADS, to: "definitionNote" )
    map.externalAuthorityNode( in: MADS, to: "hasExactExternalAuthority" )
    map.scheme( in: MADS, to: "isMemberOfMADSScheme" )
  end
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end

  def persisted?
	rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end   
end
