class MadsNameInternal
 include ActiveFedora::RdfObject
  include Dams::MadsName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
