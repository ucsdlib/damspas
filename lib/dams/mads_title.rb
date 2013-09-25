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
        map.hasAbbreviationVariant(:in => MADS, :class_name => 'MadsVariant')
        map.hasAcronymVariant(:in => MADS, :class_name => 'MadsVariant')
        map.hasExpansionVariant(:in => MADS, :class_name => 'MadsVariant')
        map.hasTranslationVariant(:in => MADS, :class_name => 'MadsVariant')
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsTitleElementList')
      end

	  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
 
      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :nonSortElement, :mainTitleElement, :partNameElement, :partNumberElement, :subTitleElement, :hasVariant, 
      							:hasAbbreviationVariant, :hasAcronymVariant, :hasExpansionVariant, :hasTranslationVariant 
      
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.Title]) if new?
        super
      end

	  ### nonSort ####
	   
      delegate :nonSortElement_attributes=, to: :elementList
      alias_method :nonSortElement, :elementList

      def nonSortElement_with_update_name= (attributes)
        self.nonSortElement_without_update_name= attributes
        self.name = authLabel
      end
      alias_method :nonSortElement_without_update_name=, :nonSortElement_attributes=
      alias_method :nonSortElement_attributes=, :nonSortElement_with_update_name=
      
      ### mainTitle ####
       
      delegate :mainTitleElement_attributes=, to: :elementList
      alias_method :mainTitleElement, :elementList
      
      def mainTitleElement_with_update_name= (attributes)
        self.mainTitleElement_without_update_name= attributes
        self.name = authLabel
      end
      alias_method :mainTitleElement_without_update_name=, :mainTitleElement_attributes=
      alias_method :mainTitleElement_attributes=, :mainTitleElement_with_update_name=
      
      ### partName ####
           
      delegate :partNameElement_attributes=, to: :elementList
      alias_method :partNameElement, :elementList

      def partNameElement_with_update_name= (attributes)
        self.partNameElement_without_update_name= attributes
        self.name = authLabel
      end
      alias_method :partNameElement_without_update_name=, :partNameElement_attributes=
      alias_method :partNameElement_attributes=, :partNameElement_with_update_name=
      
      ### partNumber ####
      
      delegate :partNumberElement_attributes=, to: :elementList
      alias_method :partNumberElement, :elementList

      def partNumberElement_with_update_name= (attributes)
        self.partNumberElement_without_update_name= attributes
        self.name = authLabel
      end
      alias_method :partNumberElement_without_update_name=, :partNumberElement_attributes=
      alias_method :partNumberElement_attributes=, :partNumberElement_with_update_name=
      
      ### subTitle ####
      
      delegate :subTitleElement_attributes=, to: :elementList
      alias_method :subTitleElement, :elementList

      def subTitleElement_with_update_name= (attributes)
        self.subTitleElement_without_update_name= attributes
        self.name = authLabel
      end
      alias_method :subTitleElement_without_update_name=, :subTitleElement_attributes=
      alias_method :subTitleElement_attributes=, :subTitleElement_with_update_name=
      
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
        get_title_value MadsMainTitleElement
	  end
	  def nonSort
	    get_title_value MadsNonSortElement
	  end
	  def partName
	    get_title_value MadsPartNameElement
	  end
	  def partNumber
	    get_title_value MadsPartNumberElement
	  end
	  def subtitle
	    get_title_value MadsSubTitleElement
	  end

	  def value=(s)
        set_title_value MadsMainTitleElement, s
	  end
	  def nonSort=(s)
        set_title_value MadsNonSortElement, s
	  end
	  def partName=(s)
        set_title_value MadsPartNameElement, s
	  end
	  def partNumber=(s)
        set_title_value MadsPartNumberElement, s
	  end
	  def subtitle=(s)
        set_title_value MadsSubTitleElement, s
	  end

	  def variant
	    get_variant(hasVariant)
	  end
	  def variant=(val)
		set_variant(hasVariant,val)
	  end

	  def translationVariant
	    get_variant(hasTranslationVariant)
	  end
	  def translationVariant=(val)
	    set_variant(hasTranslationVariant,val)
	  end

	  def abbreviationVariant
	    get_variant(hasAbbreviationVariant)
	  end
	  def abbreviationVariant=(val)
		set_variant(hasAbbreviationVariant,val)
	  end
	  
	  def acronymVariant
	    get_variant(hasAcronymVariant)
	  end
	  def acronymVariant=(val)
		set_variant(hasAcronymVariant,val)
	  end
	  
	  def expansionVariant
	    get_variant(hasExpansionVariant)
	  end
	  def expansionVariant=(val)
		set_variant(hasExpansionVariant,val)
	  end
	  	  	  	  
	  def set_variant(type, val)
	  	if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      type.build if type[0] == nil
	      type[0].variantLabel = val
	    end	  	
	  end
	  	  
	  def get_variant(type)
	  	if (!type.nil? && type.length > 0)
	  		type[0] ? type[0].variantLabel.first: []
	  	end
	  end
	    
      def get_elem(klass)
        idx = 0
        while idx < elementList.size
          return elementList[idx] if elementList[idx].class == klass
          idx += 1
        end
      end
      def get_title_value(klass)
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
      def set_title_value( klass, val )
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
