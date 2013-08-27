class MadsPersonalNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsPersonalName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
