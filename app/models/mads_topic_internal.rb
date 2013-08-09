class MadsTopicInternal
  include ActiveFedora::RdfObject
  include Dams::MadsTopic
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
