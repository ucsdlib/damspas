require 'active_support/concern'

module Dams
  module DamsOtherRights
    extend ActiveSupport::Concern
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
        graph.insert([rdf_subject, RDF.type, DAMS.OtherRights]) if new?
        super
      end

	  def name
	    relationship[0] ? relationship[0].name : []
	  end
	  def name=(val)
	    if relationship[0] == nil
	      relationship.build
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
	    relationship[0].role = RDF::Resource.new(val)
	  end   

      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'basis', basis)
        Solrizer.insert_field(solr_doc, 'uri', uri)
        Solrizer.insert_field(solr_doc, 'note', note)
	    relationship.map do |relationship|
	      Solrizer.insert_field(solr_doc, 'decider', relationship.load.name )
	    end                       
      end
    end
  end
end
