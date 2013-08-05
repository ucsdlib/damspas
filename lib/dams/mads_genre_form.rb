require 'active_support/concern'

module Dams
  module MadsGenreForm
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.GenreForm
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsGenreFormElementList')
      end
      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :genreFormElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.GenreForm]) if new?
        super
      end
      delegate :genreFormElement_attributes=, to: :elementList
      alias_method :genreFormElement, :elementList
      def genreFormElement_with_update_name= (attributes)
        self.genreFormElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :genreFormElement_without_update_name=, :genreFormElement_attributes=
      alias_method :genreFormElement_attributes=, :genreFormElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'genre_form', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "genre_form_element", elementList.first.elementValue.to_s)
        end
        solr_base solr_doc
      end
      class MadsGenreFormElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.genreFormElement(:in=> MADS, :to =>"GenreFormElement", :class_name => "MadsGenreFormElement")
        end
        accepts_nested_attributes_for :genreFormElement
      end
    end
  end
end
