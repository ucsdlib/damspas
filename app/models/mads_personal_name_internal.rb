class MadsPersonalNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsPersonalName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
end
