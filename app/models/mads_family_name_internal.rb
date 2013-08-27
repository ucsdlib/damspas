class MadsFamilyNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsFamilyName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
