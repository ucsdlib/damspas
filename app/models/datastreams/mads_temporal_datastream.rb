class MadsTemporalDatastream < ActiveFedora::RdfxmlRDFDatastream
  include ActiveFedora::Rdf::DefaultNodes
  rdf_type MADS.Temporal
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthority(:in => MADS, :to => 'hasExactExternalAuthority')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme', :class_name => 'MadsSchemeInternal')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'MadsTemporalNestedElementList')
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    
  accepts_nested_attributes_for :elementList, :scheme

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Temporal]) if new?
    super
  end


  def elementList_attributes_with_update_name= (attributes)
    self.elementList_attributes_without_update_name= attributes
    if elementList.first && elementList.first.first && elementList.first.first.elementValue.first
      self.name = elementList.first.first.elementValue.first
    end
  end
  alias_method :elementList_attributes_without_update_name=, :elementList_attributes=
  alias_method :elementList_attributes=, :elementList_attributes_with_update_name=
  
  class MadsTemporalNestedElementList
    include ActiveFedora::RdfList
    map_predicates do |map|
      map.temporalElement(:in=> MADS, :to =>"TemporalElement", :class_name => "MadsTemporalElement")
    end
    accepts_nested_attributes_for :temporalElement
    
    # used by fields_for, so this ought to move to ActiveFedora if it works
    def persisted?
      rdf_subject.kind_of? RDF::URI
    end
    def id
      rdf_subject if rdf_subject.kind_of? RDF::URI
    end   
  end
  class MadsTemporalElement
    include ActiveFedora::RdfObject
    rdf_type MADS.TemporalElement
    map_predicates do |map|
      map.elementValue(:in=> MADS)
    end
    # used by fields_for, so this ought to move to ActiveFedora if it works
    def persisted?
      rdf_subject.kind_of? RDF::URI
    end
    def id
      rdf_subject if rdf_subject.kind_of? RDF::URI
    end    
  end
  def label
	name[0]
  end
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'temporal', name)
    if scheme.first
      Solrizer.insert_field(solr_doc, 'scheme', scheme.first.rdf_subject.to_s)
      Solrizer.insert_field(solr_doc, 'scheme_name', scheme.first.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', scheme.first.code.first)
    end
    Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.first.to_s)
    if elementList.first
      Solrizer.insert_field(solr_doc, "temporal_element", elementList[0].first.elementValue)
    end
    solr_doc
  end
end
