class MadsLanguageInternal
  include ActiveFedora::RdfObject
  include Dams::MadsLanguage
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
