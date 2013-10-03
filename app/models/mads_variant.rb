class MadsVariant
  include ActiveFedora::RdfObject
  include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.Variant
  map_predicates do |map|
    map.variantLabel(:in=>MADS)
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end 
end
