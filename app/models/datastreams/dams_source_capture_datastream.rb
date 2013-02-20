class DamsSourceCaptureDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.scannerManufacturer(:in => DAMS, :to => 'scannerManufacturer')
    map.sourceType(:in => DAMS, :to => 'sourceType')
    map.scannerModel(:in => DAMS, :to => 'scannerModel')
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
    # need to make these support multiples too
    Solrizer.insert_field(solr_doc, 'scannerManufacturer', scannerManufacturer.first.value)
    Solrizer.insert_field(solr_doc, 'sourceType', sourceType.first.value)
    Solrizer.insert_field(solr_doc, 'scannerModel', scannerModel.first.value)
    Solrizer.insert_field(solr_doc, 'sourceType', sourceType.first.value)
    Solrizer.insert_field(solr_doc, 'imageProducer', imageProducer.first.value)
    Solrizer.insert_field(solr_doc, 'scanningSoftwareVersion', scanningSoftwareVersion.first.value)
    Solrizer.insert_field(solr_doc, 'scanningSoftware', scanningSoftware.first.value)
    Solrizer.insert_field(solr_doc, 'captureSource', captureSource.first.value)
    
    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }
    return solr_doc
  end
end
