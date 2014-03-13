class DamsSourceCaptureInternal
  include ActiveFedora::RdfObject
  map_predicates do |map|
    map.scannerManufacturer(:in => DAMS, :to => 'scannerManufacturer')
    map.sourceType(:in => DAMS, :to => 'sourceType')
    map.scannerModelName(:in => DAMS, :to => 'scannerModelName')
    map.imageProducer(:in => DAMS, :to => 'imageProducer')
    map.scanningSoftwareVersion(:in => DAMS, :to => 'scanningSoftwareVersion')
    map.scanningSoftware(:in => DAMS, :to => 'scanningSoftware')
    map.captureSource(:in => DAMS, :to => 'captureSource')
  end

  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }
  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.SourceCapture]) if new?
    super
  end
  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end

end
