class DamsSourceCaptureDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.scannerManufacturer(:in => DAMS, :to => 'scannerManufacturer')
    map.sourceType(:in => DAMS, :to => 'sourceType')
    map.scannerModelName(:in => DAMS, :to => 'scannerModelName')
    map.imageProducer(:in => DAMS, :to => 'imageProducer')
    map.scanningSoftwareVersion(:in => DAMS, :to => 'scanningSoftwareVersion')
    map.scanningSoftware(:in => DAMS, :to => 'scanningSoftware')
    map.captureSource(:in => DAMS, :to => 'captureSource')
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.SourceCapture]) if new?
    super
  end

  def to_solr (solr_doc = {})
    
    solr_doc[ActiveFedora::SolrService.solr_name("scannerManufacturer", type: :text)] = scannerManufacturer
    solr_doc[ActiveFedora::SolrService.solr_name("sourceType", type: :text)] = sourceType
    solr_doc[ActiveFedora::SolrService.solr_name("scannerModelName", type: :text)] = scannerModelName
    solr_doc[ActiveFedora::SolrService.solr_name("imageProducer", type: :text)] = imageProducer
    solr_doc[ActiveFedora::SolrService.solr_name("scanningSoftwareVersion", type: :text)] = scanningSoftwareVersion
    solr_doc[ActiveFedora::SolrService.solr_name("scanningSoftware", type: :text)] = scanningSoftware
    solr_doc[ActiveFedora::SolrService.solr_name("captureSource", type: :text)] = captureSource
    
    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
