class MadsConferenceNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsConferenceName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end    
end
