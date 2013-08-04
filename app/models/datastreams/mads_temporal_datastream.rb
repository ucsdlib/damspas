class MadsTemporalDatastream < ActiveFedora::RdfxmlRDFDatastream
  #include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.Temporal
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
    map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'MadsTemporalElementList')
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    
  accepts_nested_attributes_for :temporalElement, :scheme

  # this is conceptual, not real working code:
  # has_one :elementList
  # has_many :temporal_elements, :through => :elementList

  def elementList
    elem_list.first || elem_list.build
  end

  delegate :temporalElement_attributes=, to: :elementList
  alias_method :temporalElement, :elementList
  
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Temporal]) if new?
    super
  end

  def temporalElement_with_update_name= (attributes)
    self.temporalElement_without_update_name= attributes
    if elementList && elementList.first && elementList.first.elementValue.present?
      self.name = elementList.first.elementValue
    end
  end
  alias_method :temporalElement_without_update_name=, :temporalElement_attributes=
  alias_method :temporalElement_attributes=, :temporalElement_with_update_name=
  
  class MadsTemporalElementList
    include ActiveFedora::RdfList
    map_predicates do |map|
      map.temporalElement(:in=> MADS, :to =>"TemporalElement", :class_name => "MadsTemporalElement")
    end
    accepts_nested_attributes_for :temporalElement
    
    # used by fields_for, so this ought to move to ActiveFedora if it works
    #def persisted?
    #  rdf_subject.kind_of? RDF::URI
    #end
    #def id
    #  rdf_subject if rdf_subject.kind_of? RDF::URI
    #end   
  end
  def label
	name[0]
  end
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'name', name)
    Solrizer.insert_field(solr_doc, 'temporal', name)
    if scheme.first
      Solrizer.insert_field(solr_doc, 'scheme', scheme.first.rdf_subject.to_s)
      Solrizer.insert_field(solr_doc, 'scheme_name', scheme.first.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', scheme.first.code.first)
    end
    Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
    if elementList.first
      Solrizer.insert_field(solr_doc, "temporal_element", elementList.first.elementValue.to_s)
    end
    solr_doc
  end
end
