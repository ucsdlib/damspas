class MadsLanguageInternal
  include ActiveFedora::RdfObject
  include Dams::MadsLanguage
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  
end
