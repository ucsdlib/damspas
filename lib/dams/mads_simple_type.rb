module Dams
  module MadsSimpleType
    # = MADS SimpleType, extended by MADS Topic, Geographic, etc.
    extend ActiveSupport::Concern
    included do
      rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
      map_predicates do |map|
        map.name(:in => MADS, :to => 'authoritativeLabel')
        map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
        map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
      end
      def solr_base (solr_doc={})
        Solrizer.insert_field(solr_doc, 'name', name)
        if scheme.first
          Solrizer.insert_field(solr_doc, 'scheme', scheme.first.rdf_subject.to_s)
          Solrizer.insert_field(solr_doc, 'scheme_name', scheme.first.name.first)
          Solrizer.insert_field(solr_doc, 'scheme_code', scheme.first.code.first)
        end
        Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
        solr_doc
      end
    end
  end
end
