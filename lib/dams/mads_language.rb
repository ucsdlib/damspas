require 'active_support/concern'

module Dams
  module MadsLanguage
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.Language
      map_predicates do |map|
        map.code(:in => MADS)
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsLanguageElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :languageElement, :scheme
      def serialize
        check_type( graph, rdf_subject, MADS.Language )
        super
      end
      delegate :languageElement_attributes=, to: :elementList
      alias_method :languageElement, :elementList
      def languageElement_with_update_name= (attributes)
        self.languageElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :languageElement_without_update_name=, :languageElement_attributes=
      alias_method :languageElement_attributes=, :languageElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'language', name)
        Solrizer.insert_field(solr_doc, 'code', code.first)
        if elementList.first
          Solrizer.insert_field(solr_doc, "language_element", elementList.first.elementValue.to_s)
        end
        # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
      class MadsLanguageElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.languageElement(:in=> MADS, :to =>"LanguageElement", :class_name => "MadsLanguageElement")
        end
        accepts_nested_attributes_for :languageElement
      end
	  class MadsLanguageElement
	    include Dams::MadsElement
	    rdf_type MADS.LanguageElement
	  end      
    end
  end
end
