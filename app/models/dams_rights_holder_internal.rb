class DamsRightsHolderInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include DamsHelper
    map_predicates do |map|
       map.name(:in => MADS, :to => 'authoritativeLabel')   
    end

	rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

	def pid
	   rdf_subject.to_s.gsub(/.*\//,'')
	end
      
end
