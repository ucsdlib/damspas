class MadsCorporateNameInternal
  include ActiveFedora::RdfObject
  include Dams::MadsCorporateName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
