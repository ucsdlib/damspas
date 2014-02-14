class DamsCustodialResponsibilityNoteInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    rdf_type DAMS.CustodialResponsibilityNote
    map_predicates do |map|
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }

  	def pid
      	rdf_subject.to_s.gsub(/.*\//,'')
  	end
    def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsCustodialResponsibilityNote.find(md[1])
      end
    end
    def persisted?
    	rdf_subject.kind_of? RDF::URI
    end    
end
