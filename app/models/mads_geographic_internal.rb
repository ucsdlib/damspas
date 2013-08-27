class MadsGeographicInternal
  include ActiveFedora::RdfObject
  include Dams::MadsGeographic
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
