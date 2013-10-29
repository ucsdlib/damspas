require 'active_support/concern'

module Dams
  module DamsOtherRight
    extend ActiveSupport::Concern
    include ModelHelper
    included do
      rdf_type DAMS.OtherRights
	  map_predicates do |map|
	    map.basis(:in => DAMS, :to => 'otherRightsBasis')
	    map.note(:in => DAMS, :to => 'otherRightsNote')
	    map.uri(:in => DAMS, :to => 'otherRightsURI')
	    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
	    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
	    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
	  end
   	  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
      accepts_nested_attributes_for :relationship, :permission_node, :restriction_node

      def serialize
        check_type( graph, rdf_subject, DAMS.OtherRights )
        super
      end

	  def name
	    relationship[0] ? relationship[0].name : []
	  end
	  def name=(val)
	    if relationship[0] == nil
	      relationship.build
	    end
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.include? "#{Rails.configuration.id_namespace}")
	    	val = "#{Rails.configuration.id_namespace}#{val}"
	    end
	    relationship[0].name = RDF::Resource.new(val)
	  end
	  def role
	    relationship[0] ? relationship[0].role : []
	  end
	  def role=(val)
	    if relationship[0] == nil
	      relationship.build
	    end
	    if val.class == Array
	    	val = val.first
	    end	    
	    if(!val.include? "#{Rails.configuration.id_namespace}")
	    	val = "#{Rails.configuration.id_namespace}#{val}"
	    end
	    relationship[0].role = RDF::Resource.new(val)
	  end   

      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'basis', basis)
        Solrizer.insert_field(solr_doc, 'uri', uri)
        Solrizer.insert_field(solr_doc, 'note', note)
	    Solrizer.insert_field(solr_doc, "permissionType", permissionType)
	    Solrizer.insert_field(solr_doc, "permissionBeginDate", permissionBeginDate)
	    Solrizer.insert_field(solr_doc, "permissionEndDate", permissionEndDate)
	    Solrizer.insert_field(solr_doc, "restrictionType", restrictionType)
	    Solrizer.insert_field(solr_doc, "restrictionBeginDate", restrictionBeginDate)
	    Solrizer.insert_field(solr_doc, "restrictionEndDate", restrictionEndDate)
	    if !relationship.nil? && !relationship[0].nil?
			Solrizer.insert_field(solr_doc, "relationship_role", relationship.first.loadRole.name)
	    	Solrizer.insert_field(solr_doc, "relationship_name", relationship.first.load.name)
	    end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }	          
	   # relationship.map do |relationship|
	   #   Solrizer.insert_field(solr_doc, 'decider', relationship.load.name )
	   # end
	    return solr_doc                      
      end
    end
  end
end
