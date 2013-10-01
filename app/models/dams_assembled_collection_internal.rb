class DamsAssembledCollectionInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    include Dams::DamsAssembledCollection
    
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
