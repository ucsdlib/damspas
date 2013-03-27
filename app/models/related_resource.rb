  class RelatedResource
    include ActiveFedora::RdfObject
    rdf_type DAMS.RelatedResource
    map_predicates do |map|
      map.type(:in=> DAMS)
      map.description(:in=> DAMS)
      map.uri(:in=> DAMS)
    end
  end