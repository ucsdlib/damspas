class DamsAssembledCollectionInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    include Dams::AssembledCollection
    
  
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
