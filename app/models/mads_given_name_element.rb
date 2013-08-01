class MadsGivenNameElement
  include ActiveFedora::RdfObject
  rdf_type MADS.GivenNameElement
  map_predicates do |map|
    map.elementValue(:in=> MADS)
  end
  # used by fields_for, so this ought to move to ActiveFedora if it works
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end
end
