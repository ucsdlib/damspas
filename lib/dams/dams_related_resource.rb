require 'active_support/concern'

module Dams
  module DamsRelatedResource
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.RelatedResource

	  map_predicates do |map|
	      map.type(:in=> DAMS)
	      map.description(:in=> DAMS)
	      map.uri(:in=> DAMS)
	  end
     
      def serialize
        check_type( graph, rdf_subject, DAMS.RelatedResource )
        super
      end
      
      def to_solr (solr_doc={})
 		Solrizer.insert_field(solr_doc, "type", type.first )
    	Solrizer.insert_field(solr_doc, "relatedResourceURI", uri.first )
    	Solrizer.insert_field(solr_doc, "relatedResourceDescription", description.first )

        # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
      
    end
  end
end
