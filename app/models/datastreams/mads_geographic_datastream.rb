class MadsGeographicDatastream < ActiveFedora::RdfxmlRDFDatastream
  rdf_type MADS.Geographic
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
    map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsGeographicElementList')
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  accepts_nested_attributes_for :geographicElement, :scheme

  # this is conceptual, not real working code:
  # has_one :elementList
  # has_many :geographic_elements, :through => :elementList

  def elementList
    elem_list.first || elem_list.build
  end

  delegate :geographicElement_attributes=, to: :elementList
  alias_method :geographicElement, :elementList

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Geographic]) if new?
    super
  end


  def geographicElement_with_update_name= (attributes)
    self.geographicElement_without_update_name= attributes
    if elementList && elementList.first && elementList.first.elementValue.present?
      self.name = elementList.first.elementValue
    end
  end
  alias_method :geographicElement_without_update_name=, :geographicElement_attributes=
  alias_method :geographicElement_attributes=, :geographicElement_with_update_name=

  class MadsGeographicElementList
    include ActiveFedora::RdfList
    map_predicates do |map|
      map.geographicElement(:in=> MADS, :to =>"GeographicElement", :class_name => "MadsGeographicElement")
    end
    accepts_nested_attributes_for :geographicElement
  end
  class MadsGeographicElement
    include ActiveFedora::RdfObject
    rdf_type MADS.GeographicElement
    map_predicates do |map|
      map.elementValue(in: MADS, multivalue: false)
    end
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
    Solrizer.insert_field(solr_doc, 'geographic', name)
    if scheme.first
      Solrizer.insert_field(solr_doc, 'scheme', scheme.first.rdf_subject.to_s)
      Solrizer.insert_field(solr_doc, 'scheme_name', scheme.first.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', scheme.first.code.first)
    end
    Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
    if elementList.first
      Solrizer.insert_field(solr_doc, "geographic_element", elementList.first.elementValue.to_s)
    end
    solr_doc
  end
end
