require 'active_support/concern'

module Dams
  module MadsTemporal
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.Temporal
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsTemporalElementList')
      end
      def elementList
        elem_list.first || elem_list.build
      end
      accepts_nested_attributes_for :temporalElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.Temporal]) if new?
        super
      end
      delegate :temporalElement_attributes=, to: :elementList
      alias_method :temporalElement, :elementList
      def temporalElement_with_update_name= (attributes)
        self.temporalElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :temporalElement_without_update_name=, :temporalElement_attributes=
      alias_method :temporalElement_attributes=, :temporalElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'temporal', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "temporal_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }        
        solr_base solr_doc
      end
      def label
		name[0]
	  end
      class MadsTemporalElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.temporalElement(:in=> MADS, :to =>"TemporalElement", :class_name => "MadsTemporalElement")
        end
        accepts_nested_attributes_for :temporalElement
      end
	  class MadsTemporalElement
		include Dams::MadsElement
		rdf_type MADS.TemporalElement
	  end      
    end
  end
end
