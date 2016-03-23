require 'active_support/concern'

module Dams
  module DamsAnatomy
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Anatomy
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsAnatomyElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :anatomyElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.Anatomy )
        super
      end
      delegate :anatomyElement_attributes=, to: :elementList
      alias_method :anatomyElement, :elementList
      def anatomyElement_with_update_name= (attributes)
        self.anatomyElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :anatomyElement_without_update_name=, :anatomyElement_attributes=
      alias_method :anatomyElement_attributes=, :anatomyElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'anatomy', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "anatomy_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsAnatomyElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.anatomyElement(:in=> DAMS, :to =>"AnatomyElement", :class_name => "DamsAnatomyElement")
      end
      accepts_nested_attributes_for :anatomyElement
    end
    class DamsAnatomyElement
      include Dams::MadsElement
      rdf_type DAMS.AnatomyElement
    end
  end
end
