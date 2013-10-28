require 'active_support/concern'

module Dams
  module DamsStylePeriod
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.StylePeriod
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsStylePeriodElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :stylePeriodElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.StylePeriod )
        super
      end
      delegate :stylePeriodElement_attributes=, to: :elementList
      alias_method :stylePeriodElement, :elementList
      def stylePeriodElement_with_update_name= (attributes)
        self.stylePeriodElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :stylePeriodElement_without_update_name=, :stylePeriodElement_attributes=
      alias_method :stylePeriodElement_attributes=, :stylePeriodElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'style_period', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "style_period_element", elementList.first.elementValue.to_s)
        end
        
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
	    solr_base solr_doc
      end
    end
    class DamsStylePeriodElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.stylePeriodElement(:in=> DAMS, :to =>"StylePeriodElement", :class_name => "DamsStylePeriodElement")
      end
      accepts_nested_attributes_for :stylePeriodElement
    end
    class DamsStylePeriodElement
      include Dams::MadsElement
      rdf_type DAMS.StylePeriodElement
    end
  end
end
