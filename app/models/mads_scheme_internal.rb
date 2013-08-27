class MadsSchemeInternal
  include ActiveFedora::RdfObject
  include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type MADS.MADSScheme
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: RDF::RDFS, to: "label" )
  end 

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  
  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
  # used by fields_for, so this ought to move to ActiveFedora if it works
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

  def attributes=(values)
    if rdf_subject.uri? && (!values.key?('code') || !values.key?('name'))
      remote_scheme = Dams.resolve_object(rdf_subject)
      raise "Expected a MadsScheme at #{rdf_subject}, but got #{remote_scheme.class}." unless remote_scheme.kind_of? MadsScheme
      values['code'] = remote_scheme.code
      values['name'] = remote_scheme.name 
    end
    super(values)
  end

end
