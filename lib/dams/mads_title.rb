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
        get_value "MainTitleElement"
	  end
	  def nonSort
	    get_value "NonSortElement"
	  end
	  def partName
	    get_value "PartNameElement"
	  end
	  def partNumber
	    get_value "PartNumberElement"
	  end
	  def subtitle
	    get_value "SubTitleElement"
	  end

	  def value=(s)
        set_value elementList.mainTitleElement, s
	  end
	  def nonSort=(s)
        set_value elementList.nonSortElement, s
	  end
	  def partName=(s)
        set_value elementList.partNameElement, s
	  end
	  def partNumber=(s)
        set_value elementList.partNumberElement, s
	  end
	  def subtitle=(s)
        set_value elementList.subTitleElement, s
	  end

      def get_value(name)
        el = elementList
        idx = 0
        while idx < el.size
          elem = el[idx]
          
          if elem.class.name.include? name
            if(elem.elementValue.nil?)
              return nil
            elsif(elem.elementValue.first == nil || elem.elementValue.first.size > elem.elementValue.size )
              return elem.elementValue.first
            else
              return elem.elementValue.to_s
            end
          end
          idx += 1
        end
      end
      def set_value( elem, val )
        e = elem.first
        if e.nil?
          e = elem.build
          elem[0] = e
        end
        e.elementValue = val

        # also set authoritativeLabel
        if !authLabel.blank? && name.size > 0 
          name[0] = authLabel
        else !authLabel.blank?
          name << authLabel
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
