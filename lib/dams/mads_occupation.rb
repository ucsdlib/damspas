require 'active_support/concern'

module Dams
  module MadsOccupation
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.Occupation
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsOccupationElementList')
      end
      def elementList
        elem_list.first || elem_list.build
      end
      accepts_nested_attributes_for :occupationElement, :scheme
      def serialize
        check_type( graph, rdf_subject, MADS.Occupation )
        super
      end
      delegate :occupationElement_attributes=, to: :elementList
      alias_method :occupationElement, :elementList
      def occupationElement_with_update_name= (attributes)
        self.occupationElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :occupationElement_without_update_name=, :occupationElement_attributes=
      alias_method :occupationElement_attributes=, :occupationElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'occupation', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "occupation_element", elementList.first.elementValue.to_s)
        end
        solr_base solr_doc
      end
      class MadsOccupationElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.occupationElement(:in=> MADS, :to =>"OccupationElement", :class_name => "MadsOccupationElement")
        end
        accepts_nested_attributes_for :occupationElement
      end
	  class MadsOccupationElement
    	include Dams::MadsElement
    	rdf_type MADS.OccupationElement
	  end      
    end
  end
end
