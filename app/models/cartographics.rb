class Cartographics
    include ActiveFedora::RdfObject
    rdf_type DAMS.Cartographics
    map_predicates do |map|
      map.point(:in=>DAMS)
      map.line(:in=>DAMS)
      map.polygon(:in=>DAMS)
      map.projection(:in=>DAMS)
      map.referenceSystem(:in=>DAMS)
      map.scale(:in=>DAMS)
    end
    def to_solr (solr_doc = {})
      super solr_doc
    end
end