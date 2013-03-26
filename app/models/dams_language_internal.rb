  class DamsLanguageInternal
    include ActiveFedora::RdfObject
    rdf_type DAMS.Language

    map_predicates do |map|
      map.code(:in => DAMS, :to => 'code')
      map.value(:in => RDF, :to => 'value')
      map.valueURI(:in => DAMS, :to => 'valueURI')
      map.vocab(:in => DAMS, :to => 'vocabulary', :class_name => 'DamsVocabulary')
    end
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    def pid
      rdf_subject.to_s.gsub(/.*\//,'')
    end
  end
