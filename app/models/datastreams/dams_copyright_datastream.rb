class DamsCopyrightDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.status(:in => DAMS, :to => 'copyrightStatus')
    map.jurisdiction(:in => DAMS, :to => 'copyrightJurisdiction')
    map.purposeNote(:in => DAMS, :to => 'copyrightPurposeNote')
    map.note(:in => DAMS, :to => 'copyrightNote')
    map.date_node(:in => DAMS, :to=>'date', :class_name => 'Date')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Copyright]) if new?
    super
  end

  def beginDate
    date_node.first ? date_node.first.beginDate : []
  end

  def beginDate=(val)
    self.date_node = []
    date_node.build.beginDate = val
  end

  class Date
    include ActiveFedora::RdfObject
    rdf_type DAMS.Date
    map_predicates do |map|
      map.beginDate(:in=>DAMS)
    end
  end

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("status", type: :text)] = status

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
