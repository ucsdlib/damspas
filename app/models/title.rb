class Title
    include ActiveFedora::RdfObject
    rdf_type DAMS.Title
    map_predicates do |map|
      map.value(:in=> RDF)
      map.subtitle(:in=> DAMS)
      map.type(:in=> DAMS)
    end
end