require 'active_support/concern'

module Dams
  module MadsCorporateName
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    #include Dams::MadsNameElements
    included do
      rdf_type MADS.CorporateName
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsCorporateNameElementList')
      end
      def elementList
        elem_list.first || elem_list.build
      end
      accepts_nested_attributes_for :scheme, :nameElement, :fullNameElement, :givenNameElement, :familyNameElement, :dateNameElement, :termsOfAddressNameElement
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.CorporateName]) if new?
        super
      end

      delegate :nameElement_attributes=, to: :elementList
      alias_method :nameElement, :elementList
      def nameElement_and_name= (attributes)
        self.nameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :nameElement_only=, :nameElement_attributes=
      alias_method :nameElement_attributes=, :nameElement_and_name=

      delegate :fullNameElement_attributes=, to: :elementList
      alias_method :fullNameElement, :elementList
      def fullNameElement_and_name= (attributes)
        self.fullNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :fullNameElement_only=, :fullNameElement_attributes=
      alias_method :fullNameElement_attributes=, :fullNameElement_and_name=
      
      delegate :fullNameElement_attributes=, to: :elementList
      alias_method :fullNameElement, :elementList
      def fullNameElement_and_name= (attributes)
        self.fullNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :fullNameElement_only=, :fullNameElement_attributes=
      alias_method :fullNameElement_attributes=, :fullNameElement_and_name=

      delegate :givenNameElement_attributes=, to: :elementList
      alias_method :givenNameElement, :elementList
      def givenNameElement_and_name= (attributes)
        self.givenNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :givenNameElement_only=, :givenNameElement_attributes=
      alias_method :givenNameElement_attributes=, :givenNameElement_and_name=

      delegate :familyNameElement_attributes=, to: :elementList
      alias_method :familyNameElement, :elementList
      def familyNameElement_and_name= (attributes)
        self.familyNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :familyNameElement_only=, :familyNameElement_attributes=
      alias_method :familyNameElement_attributes=, :familyNameElement_and_name=

      delegate :dateNameElement_attributes=, to: :elementList
      alias_method :dateNameElement, :elementList
      def dateNameElement_and_name= (attributes)
        self.dateNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :dateNameElement_only=, :dateNameElement_attributes=
      alias_method :dateNameElement_attributes=, :dateNameElement_and_name=

      delegate :termsOfAddressNameElement_attributes=, to: :elementList
      alias_method :termsOfAddressNameElement, :elementList
      def termsOfAddressNameElement_and_name= (attributes)
        self.termsOfAddressNameElement_only= attributes
        self.name = authLabel #if attributes['name'].blank? && authLabel
      end
      alias_method :termsOfAddressNameElement_only=, :termsOfAddressNameElement_attributes=
      alias_method :termsOfAddressNameElement_attributes=, :termsOfAddressNameElement_and_name=

      def authLabel
        full = fullNameValue
        given = givenNameValue
        family = familyNameValue
        addr = termsOfAddressNameValue
        date = dateNameValue
        nameVal = nameValue

        authLabel = ""
        [full,family,given,addr,date,nameVal].each do |val|
          if val
            authLabel += ", " if !authLabel.blank?
            authLabel += val
          end
        end
        authLabel
      end
      def nameValue
        get_value "MadsNameElement"
      end
      def familyNameValue
        get_value "MadsFamilyNameElement"
      end
      def fullNameValue
        get_value "MadsFullNameElement"
      end
      def givenNameValue
        get_value "MadsGivenNameElement"
      end
      def dateNameValue
        get_value "MadsDateNameElement"
      end
      def termsOfAddressNameValue
        get_value "MadsTermsOfAddressNameElement"
      end
      def get_value(name)
        el = elementList
        idx = 0
        while idx < el.size
          elem = el[idx]
          
          if elem.class.name.include? name
          	if(name.include? "MadsNameElement")
          		return elem.elementValue.to_s
          	else
            	return elem.elementValue.first
            end
          end
          idx += 1
        end
      end
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'corporate_name', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "name_element", nameValue)
          Solrizer.insert_field(solr_doc, "given_name_element", givenNameValue)
          Solrizer.insert_field(solr_doc, "full_name_element", fullNameValue)
          Solrizer.insert_field(solr_doc, "family_name_element", familyNameValue)
          Solrizer.insert_field(solr_doc, "date_name_element", dateNameValue)
          Solrizer.insert_field(solr_doc, "terms_of_address_name_element", termsOfAddressNameValue)
        end
        solr_base solr_doc
      end
      class MadsCorporateNameElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.nameElement(:in=> MADS, :to =>"NameElement", :class_name => "MadsNameElement")
          map.givenNameElement(:in=> MADS, :to =>"GivenNameElement", :class_name => "MadsGivenNameElement")
          map.fullNameElement(:in=> MADS, :to =>"FullNameElement", :class_name => "MadsFullNameElement")
          map.familyNameElement(:in=> MADS, :to =>"FamilyNameElement", :class_name => "MadsFamilyNameElement")
          map.dateNameElement(:in=> MADS, :to =>"DateNameElement", :class_name => "MadsDateNameElement")
          map.termsOfAddressNameElement(:in=> MADS, :to =>"TermsOfAddressNameElement", :class_name => "MadsTermsOfAddressNameElement")
        end
        accepts_nested_attributes_for :nameElement, :givenNameElement, :fullNameElement, :familyNameElement, :dateNameElement, :termsOfAddressNameElement
      end
    end
  end
end
