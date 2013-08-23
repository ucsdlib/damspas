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

	  def label
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
	
	    label = main
	    label += ": " + subt if subt
	    label += ", " + nons if nons
	    label += ", " + pnam if pnam
	    label += ", " + pnum if pnum
	    label
	  end
	  def value
	    getValue "MainTitleElement"
	  end
	  def nonSort
	    getValue "NonSortElement"
	  end
	  def partName
	    getValue "PartNameElement"
	  end
	  def partNumber
	    getValue "PartNumberElement"
	  end
	  def subtitle
	    getValue "SubTitleElement"
	  end
	  def value=(s)
	    setValue( "MainTitleElement", s )
	  end
	  def nonSort=(s)
	    setValue( "NonSortElement", s )
	  end
	  def partName=(s)
	    setValue( "PartNameElement", s )
	  end
	  def partNumber=(s)
	    setValue( "PartNumberElement", s )
	  end
	  def subtitle=(s)
	    setValue( "SubTitleElement", s )
	  end

      def getValue(name)
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

	  def setValue(type,val)
	    if val.class == Array
	        val = val.first
	    end
	
	    existing_elem = find_element type
	
	    #need to use eList.size to know where to insert/update the value
	    if(existing_elem != nil )
	      # set value of existing element
	      existing_elem.elementValue = val
	    else
	      # create a new element of the correct type
	      if type.include? "MainTitleElement"
	        elem = elementList.mainTitleElement.build
	      elsif type.include? "NonSortElement"
	        elem = elementList.nonSortElement.build
	      elsif type.include? "PartNameElement"
	        elem = elementList.partNameElement.build
	      elsif type.include? "PartNumberElement"
	        elem = elementList.partNumberElement.build
	      elsif type.include? "SubTitleElement"
	        elem = elementList.subTitleElement.build
	      end
	      elem.elementValue = val
	
	      # add new element to the end of the list
	      #if elementList.first.nil?
	      #  elementList.first.value = elem
	      #else
	        elementList[elementList.size] = elem
	      #end
	    end
	  end
	   
	  def find_element( type )
	    chain = elementList
	    elem = nil
	    while  elem == nil && chain != nil do
	      if chain.first.class.name.include? type
	        elem = chain.first
	      else
	        chain = chain.tail
	      end
	    end
	    elem
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
