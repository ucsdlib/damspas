class DamsCommonNameInternal
    include ActiveFedora::RdfObject
  include Dams::DamsCommonName

  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
  

  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  


end
