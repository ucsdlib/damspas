class DamsBuiltWorkPlaceInternal
    include ActiveFedora::RdfObject
  include Dams::DamsBuiltWorkPlace

  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
  
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

end