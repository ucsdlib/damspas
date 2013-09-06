class MadsVariant
  include ActiveFedora::RdfObject
  include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.Variant
  map_predicates do |map|
    map.variantLabel(:in=>MADS)
  end
end
