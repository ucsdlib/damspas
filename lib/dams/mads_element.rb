module Dams
  module MadsElement
    extend ActiveSupport::Concern
    include ActiveFedora::RdfObject
    included do
      map_predicates do |map|
        map.elementValue(in: MADS, multivalue: false)
      end
      def persisted?
        rdf_subject.kind_of? RDF::URI
      end
      def id
        rdf_subject if rdf_subject.kind_of? RDF::URI
      end
    end
  end
end
