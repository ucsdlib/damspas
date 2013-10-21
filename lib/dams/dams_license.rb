require 'active_support/concern'

module Dams
  module DamsLicense
    extend ActiveSupport::Concern
    included do
      rdf_type DAMS.License
      map_predicates do |map|
	    map.note(:in => DAMS, :to => 'licenseNote')
	    map.uri(:in => DAMS, :to => 'licenseURI')
	    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
	    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
      end
   	  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
      accepts_nested_attributes_for :restriction_node, :permission_node
      
      def serialize
        graph.insert([rdf_subject, RDF.type, DAMS.License]) if new?
        super
      end

      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'uri', uri.to_s)
        Solrizer.insert_field(solr_doc, 'note', note)
	    Solrizer.insert_field(solr_doc, "permissionType", permissionType)
	    Solrizer.insert_field(solr_doc, "permissionBeginDate", permissionBeginDate)
	    Solrizer.insert_field(solr_doc, "permissionEndDate", permissionEndDate)
	    Solrizer.insert_field(solr_doc, "restrictionType", restrictionType)
	    Solrizer.insert_field(solr_doc, "restrictionBeginDate", restrictionBeginDate)
	    Solrizer.insert_field(solr_doc, "restrictionEndDate", restrictionEndDate)                       
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
	    return solr_doc
	  end
    end
  end
end
