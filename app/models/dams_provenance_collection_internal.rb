class DamsProvenanceCollectionInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    include Dams::DamsProvenanceCollection

  def pid
      rdf_subject.to_s.gsub(/.*\//,'') 
  end
  
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollection]) if new?
    if(!@langURI.nil?)
      if new?
        graph.insert([rdf_subject, DAMS.language, @langURI])
      else
        graph.update([rdf_subject, DAMS.language, @langURI])
      end
    end    
    super
  end
end
