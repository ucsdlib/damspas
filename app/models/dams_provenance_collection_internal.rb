class DamsProvenanceCollectionInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    include Dams::DamsProvenanceCollection

   def pid
      rdf_subject.to_s.gsub(/.*\//,'') 
   end
end
