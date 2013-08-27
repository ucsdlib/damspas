class MadsGenreFormInternal
  include ActiveFedora::RdfObject
  include Dams::MadsGenreForm
  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
end
