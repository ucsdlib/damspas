require 'active_support/concern'

module Dams
  module DamsTechnique
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.Technique
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsTechniqueElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :techniqueElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, DAMS.Technique]) if new?
        super
      end
      delegate :techniqueElement_attributes=, to: :elementList
      alias_method :techniqueElement, :elementList
      def techniqueElement_with_update_name= (attributes)
        self.techniqueElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :techniqueElement_without_update_name=, :techniqueElement_attributes=
      alias_method :techniqueElement_attributes=, :techniqueElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'technique', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "technique_element", elementList.first.elementValue.to_s)
        end
        
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
	    solr_base solr_doc
      end
    end
    class DamsTechniqueElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.techniqueElement(:in=> DAMS, :to =>"TechniqueElement", :class_name => "DamsTechniqueElement")
      end
      accepts_nested_attributes_for :techniqueElement
    end
    class DamsTechniqueElement
      include Dams::MadsElement
      rdf_type DAMS.TechniqueElement
      def persisted?
        rdf_subject.kind_of? RDF::URI
      end
    end
  end
end
