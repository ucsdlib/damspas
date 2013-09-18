require 'active_support/concern'

module Dams
  module DamsCulturalContext
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.CulturalContext
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsCulturalContextElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :culturalContextElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, DAMS.CulturalContext]) if new?
        super
      end
      delegate :culturalContextElement_attributes=, to: :elementList
      alias_method :culturalContextElement, :elementList
      def culturalContextElement_with_update_name= (attributes)
        self.culturalContextElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :culturalContextElement_without_update_name=, :culturalContextElement_attributes=
      alias_method :culturalContextElement_attributes=, :culturalContextElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'cultural_context', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "cultural_context_element", elementList.first.elementValue.first.to_s)
        end
        solr_base solr_doc
      end
    end
    class DamsCulturalContextElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.culturalContextElement(:in=> DAMS, :to =>"CulturalContextElement", :class_name => "DamsCulturalContextElement")
      end
      accepts_nested_attributes_for :culturalContextElement
    end
    class DamsCulturalContextElement
      include Dams::MadsElement
      rdf_type DAMS.CulturalContextElement
    end
  end
end
