require 'active_support/concern'

module Dams
  module DamsBuiltWorkPlace
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.BuiltWorkPlace
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsBuiltWorkPlaceElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :builtWorkPlaceElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, DAMS.BuiltWorkPlace]) if new?
        super
      end
      delegate :builtWorkPlaceElement_attributes=, to: :elementList
      alias_method :builtWorkPlaceElement, :elementList
      def builtWorkPlaceElement_with_update_name= (attributes)
        self.builtWorkPlaceElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :builtWorkPlaceElement_without_update_name=, :builtWorkPlaceElement_attributes=
      alias_method :builtWorkPlaceElement_attributes=, :builtWorkPlaceElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'built_work_place', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "built_work_place_element", elementList.first.elementValue.first.to_s)
        end
        solr_base solr_doc
      end
    end
    class DamsBuiltWorkPlaceElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.builtWorkPlaceElement(:in=> DAMS, :to =>"BuiltWorkPlaceElement", :class_name => "DamsBuiltWorkPlaceElement")
      end
      accepts_nested_attributes_for :builtWorkPlaceElement
    end
    class DamsBuiltWorkPlaceElement
      include Dams::MadsElement
      rdf_type DAMS.BuiltWorkPlaceElement
    end
  end
end
