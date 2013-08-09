class MadsConferenceNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsConferenceName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
