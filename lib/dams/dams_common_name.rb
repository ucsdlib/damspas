require 'active_support/concern'

module Dams
  module DamsCommonName
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.CommonName
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsCommonNameElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :commonNameElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.CommonName )
        super
      end
      delegate :commonNameElement_attributes=, to: :elementList
      alias_method :commonNameElement, :elementList
      def commonNameElement_with_update_name= (attributes)
        self.commonNameElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :commonNameElement_without_update_name=, :commonNameElement_attributes=
      alias_method :commonNameElement_attributes=, :commonNameElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'common_name', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "common_name_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsCommonNameElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.commonNameElement(:in=> DAMS, :to =>"CommonNameElement", :class_name => "DamsCommonNameElement")
      end
      accepts_nested_attributes_for :commonNameElement
    end
    class DamsCommonNameElement
      include Dams::MadsElement
      rdf_type DAMS.CommonNameElement
    end
  end
end
