class DamsPermission
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    rdf_type DAMS.Permission
    map_predicates do |map|
      map.type(:in=>DAMS)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
    end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
end
