require 'active_support/concern'

module Dams
  module DamsScientificName
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.ScientificName
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsScientificNameElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :scientificNameElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.ScientificName )
        super
      end
      delegate :scientificNameElement_attributes=, to: :elementList
      alias_method :scientificNameElement, :elementList
      def scientificNameElement_with_update_name= (attributes)
        self.scientificNameElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :scientificNameElement_without_update_name=, :scientificNameElement_attributes=
      alias_method :scientificNameElement_attributes=, :scientificNameElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'scientific_name', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "scientific_name_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsScientificNameElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.scientificNameElement(:in=> DAMS, :to =>"ScientificNameElement", :class_name => "DamsScientificNameElement")
      end
      accepts_nested_attributes_for :scientificNameElement
    end
    class DamsScientificNameElement
      include Dams::MadsElement
      rdf_type DAMS.ScientificNameElement
    end
  end
end
