class MadsOccupationInternal < ActiveFedora::Rdf::Resource
  include Dams::MadsOccupation
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  
end
