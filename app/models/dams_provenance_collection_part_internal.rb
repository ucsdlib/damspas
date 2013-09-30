class DamsProvenanceCollectionPartInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    include Dams::DamsProvenanceCollectionPart
  
    def pid
      rdf_subject.to_s.gsub(/.*\//,'')
    end
end