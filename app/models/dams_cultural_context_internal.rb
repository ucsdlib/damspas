class DamsCulturalContextInternal
    include ActiveFedora::RdfObject
  include Dams::DamsCulturalContext

  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
  

  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

end