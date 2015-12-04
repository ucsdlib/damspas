require 'active_support/concern'

module Dams
  module DamsCruise
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Cruise
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsCruiseElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :cruiseElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.Cruise )
        super
      end
      delegate :cruiseElement_attributes=, to: :elementList
      alias_method :cruiseElement, :elementList
      def cruiseElement_with_update_name= (attributes)
        self.cruiseElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :cruiseElement_without_update_name=, :cruiseElement_attributes=
      alias_method :cruiseElement_attributes=, :cruiseElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'cruise', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "cruise_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsCruiseElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.cruiseElement(:in=> DAMS, :to =>"CruiseElement", :class_name => "DamsCruiseElement")
      end
      accepts_nested_attributes_for :cruiseElement
    end
    class DamsCruiseElement
      include Dams::MadsElement
      rdf_type DAMS.CruiseElement
    end
  end
end
