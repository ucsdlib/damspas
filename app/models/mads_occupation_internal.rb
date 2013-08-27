class MadsOccupationInternal
  include ActiveFedora::RdfObject
  include Dams::MadsOccupation
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
end
