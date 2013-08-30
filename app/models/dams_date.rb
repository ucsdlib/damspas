class DamsDate
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
  rdf_type DAMS.Date
  map_predicates do |map|
    map.value(:in=> RDF)
    map.beginDate(:in=>DAMS)
    map.endDate(:in=>DAMS)
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
end
