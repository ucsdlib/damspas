class DamsOtherRightsInternal
  include ActiveFedora::RdfObject
  include Dams::DamsOtherRights
  include DamsHelper
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
end
