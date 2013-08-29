require 'active_support/concern'

module Dams
  module MadsTitle
    extend ActiveSupport::Concern
    include Dams::MadsTitleElements
    included do
      rdf_type MADS.Title      
      map_predicates do |map|
        map.name(:in => MADS, :to => 'authoritativeLabel')
        map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
        map.hasVariant(:in => MADS, :class_name => 'MadsVariant')
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsTitleElementList')
      end

	  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
 
      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :nonSortElement, :mainTitleElement, :partNameElement, :partNumberElement, :subTitleElement
      
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.Title]) if new?
        super
      end

      delegate :nonSortElement_attributes=, to: :elementList
      alias_method :nonSortElement, :elementList

      delegate :mainTitleElement_attributes=, to: :elementList
      alias_method :mainTitleElement, :elementList
      
      delegate :partNameElement_attributes=, to: :elementList
      alias_method :partNameElement, :elementList

      delegate :partNumberElement_attributes=, to: :elementList
      alias_method :partNumberElement, :elementList

      delegate :subTitleElement_attributes=, to: :elementList
      alias_method :subTitleElement, :elementList

	  def authLabel
	    main = value
	    subt = subtitle
	    nons = nonSort
	    pnam = partName
	    pnum = partNumber
	
	    # make sure we have values not arrays
	    main = main.first if main.class == Array
	    subt = subt.first if subt.class == Array
	    nons = nons.first if nons.class == Array
	    pnam = pnam.first if pnam.class == Array
	    pnum = pnum.first if pnum.class == Array

	    authLabel = main
	    authLabel += ": " + subt if subt
	    authLabel += ", " + nons if nons
	    authLabel += ", " + pnam if pnam
	    authLabel += ", " + pnum if pnum
	    authLabel if !authLabel.blank?
	  end
	  def value
        get_value MadsMainTitleElement
	  end
	  def nonSort
	    get_value MadsNonSortElement
	  end
	  def partName
	    get_value MadsPartNameElement
	  end
	  def partNumber
	    get_value MadsPartNumberElement
	  end
	  def subtitle
	    get_value MadsSubTitleElement
	  end

	  def value=(s)
        set_value MadsMainTitleElement, s
	  end
	  def nonSort=(s)
        set_value MadsNonSortElement, s
	  end
	  def partName=(s)
        set_value MadsPartNameElement, s
	  end
	  def partNumber=(s)
        set_value MadsPartNumberElement, s
	  end
	  def subtitle=(s)
        set_value MadsSubTitleElement, s
	  end

	  def variantValue
	    hasVariant[0] ? hasVariant[0].variantLabel.first: []
	  end
	  def variantValue=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      hasVariant.build if hasVariant[0] == nil
	      hasVariant[0].variantLabel = val
	    end
	  end
  
      def get_elem(klass)
        idx = 0
        while idx < elementList.size
          return elementList[idx] if elementList[idx].class == klass
          idx += 1
        end
      end
      def get_value(klass)
        elem = get_elem(klass)
        if (elem.nil?)
          return nil
        elsif(elem.elementValue.nil?)
          return nil
        elsif(elem.elementValue.first == nil || elem.elementValue.first.size > elem.elementValue.size )
          return elem.elementValue.first
        else
          return elem.elementValue.to_s
        end
      end
      def set_value( klass, val )
        e = get_elem(klass)
        if e.nil?
          e = klass.new( graph )
          elementList[elementList.size] = e
        end
        e.elementValue = val

        # manipulate graph directly
        label = graph.first_object([nil,MADS.authoritativeLabel,nil])
        if ( !label.nil? )
          graph.update([rdf_subject, MADS.authoritativeLabel, authLabel])
        elsif ( label.blank? || label.value.blank? ) && !authLabel.blank?
          graph.insert([rdf_subject, MADS.authoritativeLabel, authLabel])
        end
      end

      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'title', name)
        Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
        if elementList.first
          Solrizer.insert_field(solr_doc, "title_element", value)
          Solrizer.insert_field(solr_doc, "sub_title_element", subtitle)
          Solrizer.insert_field(solr_doc, "part_name_element", partName)
          Solrizer.insert_field(solr_doc, "part_number_element", partNumber)
          Solrizer.insert_field(solr_doc, "non_sort_element", nonSort)
        end
        solr_base solr_doc
      end
    end
    class MadsTitleElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
          map.nonSortElement(:in=> MADS, :to =>"NonSortElement", :class_name => "MadsNonSortElement")
          map.mainTitleElement(:in=> MADS, :to =>"MainTitleElement", :class_name => "MadsMainTitleElement")
          map.partNameElement(:in=> MADS, :to =>"PartNameElement", :class_name => "MadsPartNameElement")
          map.partNumberElement(:in=> MADS, :to =>"PartNumberElement", :class_name => "MadsPartNumberElement")
          map.subTitleElement(:in=> MADS, :to =>"SubTitleElement", :class_name => "MadsSubTitleElement")
      end
      accepts_nested_attributes_for :nonSortElement, :mainTitleElement, :partNameElement, :partNumberElement, :subTitleElement
    end
    

  end
end
