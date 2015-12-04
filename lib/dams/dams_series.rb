require 'active_support/concern'

module Dams
  module DamsSeries
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Series
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsSeriesElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :seriesElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.Series )
        super
      end
      delegate :seriesElement_attributes=, to: :elementList
      alias_method :seriesElement, :elementList
      def seriesElement_with_update_name= (attributes)
        self.seriesElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :seriesElement_without_update_name=, :seriesElement_attributes=
      alias_method :seriesElement_attributes=, :seriesElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'series', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "series_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsSeriesElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.seriesElement(:in=> DAMS, :to =>"SeriesElement", :class_name => "DamsSeriesElement")
      end
      accepts_nested_attributes_for :seriesElement
    end
    class DamsSeriesElement
      include Dams::MadsElement
      rdf_type DAMS.SeriesElement
    end
  end
end
