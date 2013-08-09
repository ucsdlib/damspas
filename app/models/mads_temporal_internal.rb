class MadsTemporalInternal
    include ActiveFedora::RdfObject
    include Dams::MadsTemporal
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
