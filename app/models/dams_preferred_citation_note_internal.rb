class DamsPreferredCitationNoteInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.PreferredCitationNote
    map_predicates do |map|
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  	def pid
      	rdf_subject.to_s.gsub(/.*\//,'')
  	end
    def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsPreferredCitationNote.find(md[1])
      end
    end
end