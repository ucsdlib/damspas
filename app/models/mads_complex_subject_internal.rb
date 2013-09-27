class MadsComplexSubjectInternal
  include ActiveFedora::RdfObject
  include Dams::MadsComplexSubject
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def external?
    rdf_subject.to_s.include? Rails.configuration.id_namespace
  end
    
  def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        MadsComplexSubject.find(md[1])
      end
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
end
