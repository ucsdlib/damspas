require 'active_support/concern'

module Dams
  module DamsCopyright
    extend ActiveSupport::Concern
    include ModelHelper
    included do
      rdf_type DAMS.Copyright
      map_predicates do |map|
        map.status(:in => DAMS, :to => 'copyrightStatus')
	    map.jurisdiction(:in => DAMS, :to => 'copyrightJurisdiction')
	    map.purposeNote(:in => DAMS, :to => 'copyrightPurposeNote')
	    map.note(:in => DAMS, :to => 'copyrightNote')
	    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
      end
   	  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
      accepts_nested_attributes_for :date
      
      def serialize
        check_type( graph, rdf_subject, DAMS.Copyright )
        super
      end

      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'status', status)
        Solrizer.insert_field(solr_doc, 'jurisdiction', jurisdiction)
        Solrizer.insert_field(solr_doc, 'purposeNote', purposeNote)
        Solrizer.insert_field(solr_doc, 'note', note)
        Solrizer.insert_field(solr_doc, 'beginDate', beginDate)
        Solrizer.insert_field(solr_doc, 'endDate', endDate)
        Solrizer.insert_field(solr_doc, 'date', dateValue)                          
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
	    return solr_doc
      end
    end
  end
end
