class MadsNameInternal
 include ActiveFedora::RdfObject
  include Dams::MadsName
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  
end
