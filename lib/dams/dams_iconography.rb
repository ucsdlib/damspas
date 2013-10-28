require 'active_support/concern'

module Dams
  module DamsIconography
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Iconography
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsIconographyElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :iconographyElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.Iconography )
        super
      end
      delegate :iconographyElement_attributes=, to: :elementList
      alias_method :iconographyElement, :elementList
      def iconographyElement_with_update_name= (attributes)
        self.iconographyElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :iconographyElement_without_update_name=, :iconographyElement_attributes=
      alias_method :iconographyElement_attributes=, :iconographyElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'iconography', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "iconography_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsIconographyElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.iconographyElement(:in=> DAMS, :to =>"IconographyElement", :class_name => "DamsIconographyElement")
      end
      accepts_nested_attributes_for :iconographyElement
    end
    class DamsIconographyElement
      include Dams::MadsElement
      rdf_type DAMS.IconographyElement
    end
  end
end
