class MadsPersonalNameDatastream < ActiveFedora::RdfxmlRDFDatastream
  include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.PersonalName
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'MadsPersonalNameElementList')
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  accepts_nested_attributes_for :elementList, :scheme

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.PersonalName]) if new?
    super
  end

  def elementList_attributes_with_update_name= (attributes)
    self.elementList_attributes_without_update_name= attributes
    self.name = authLabel if !authLabel.blank?
  end
  alias_method :elementList_attributes_without_update_name=, :elementList_attributes=
  alias_method :elementList_attributes=, :elementList_attributes_with_update_name=

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
  def fullNameValue
    find_element "MadsFullNameElement"
  end
  def givenNameValue
    find_element "MadsGivenNameElement"
  end
  def nameValue
    find_element "MadsNameElement"
  end
  def familyNameValue
    find_element "MadsFamilyNameElement"
  end
  def dateNameValue
    find_element "MadsDateNameElement"
  end
  def termsOfAddressNameValue
    find_element "MadsTermsOfAddressNameElement"
  end
  def find_element( className )
    idx = 0
    elementList.build if elementList.nil?
    el = (elementList.first.nil?) ? elementList : elementList.first
    while idx < el.size
      e = el[idx]
      return e.elementValue.first if e.class.name.include? className
      idx += 1
    end
  end

  class MadsPersonalNameElementList
    include ActiveFedora::RdfList
    map_predicates do |map|
      map.nameElement(:in => MADS, :to => "NameElement",
                       :class_name => "MadsNameElement")
      map.dateNameElement(:in => MADS, :to => "DateNameElement",
                           :class_name => "MadsDateNameElement")
      map.familyNameElement(:in => MADS, :to => "FamilyNameElement",
                             :class_name => "MadsFamilyNameElement")
      map.fullNameElement(:in => MADS, :to => "FullNameElement",
                           :class_name => "MadsFullNameElement")
      map.givenNameElement(:in => MADS, :to => "GivenNameElement",
                            :class_name => "MadsGivenNameElement")
      map.termsOfAddressNameElement(:in => MADS, :to => "TermsOfAddressNameElement",
                                 :class_name => "MadsTermsOfAddressNameElement")
    end
    accepts_nested_attributes_for :nameElement, :dateNameElement, :familyNameElement, :fullNameElement, :givenNameElement, :termsOfAddressNameElement

    # used by fields_for, so this ought to move to ActiveFedora if it works
    def persisted?
      rdf_subject.kind_of? RDF::URI
    end
    def id
      rdf_subject if rdf_subject.kind_of? RDF::URI
    end
  end

  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'name', name)
    Solrizer.insert_field(solr_doc, 'personal_name', name)
    if scheme.first
      Solrizer.insert_field(solr_doc, 'scheme', scheme.first.rdf_subject.to_s)
      Solrizer.insert_field(solr_doc, 'scheme_name', scheme.first.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', scheme.first.code.first)
    end
    if externalAuthority.first
      Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
    end
    Solrizer.insert_field(solr_doc, "name_element", nameValue)
    Solrizer.insert_field(solr_doc, "date_name_element", dateNameValue)
    Solrizer.insert_field(solr_doc, "family_name_element", familyNameValue)
    Solrizer.insert_field(solr_doc, "full_name_element", fullNameValue)
    Solrizer.insert_field(solr_doc, "given_name_element", givenNameValue)
    Solrizer.insert_field(solr_doc, "terms_of_address_element", termsOfAddressNameValue)
  end
 
end
