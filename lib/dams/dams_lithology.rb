require 'active_support/concern'

module Dams
  module DamsLithology
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Lithology
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsLithologyElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :lithologyElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.Lithology )
        super
      end
      delegate :lithologyElement_attributes=, to: :elementList
      alias_method :lithologyElement, :elementList
      def lithologyElement_with_update_name= (attributes)
        self.lithologyElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :lithologyElement_without_update_name=, :lithologyElement_attributes=
      alias_method :lithologyElement_attributes=, :lithologyElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'lithology', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "lithology_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsLithologyElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.lithologyElement(:in=> DAMS, :to =>"LithologyElement", :class_name => "DamsLithologyElement")
      end
      accepts_nested_attributes_for :lithologyElement
    end
    class DamsLithologyElement
      include Dams::MadsElement
      rdf_type DAMS.LithologyElement
    end
  end
end
