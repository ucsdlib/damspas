class DamsLicenseDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  map_predicates do |map|
    map.note(:in => DAMS, :to => 'licenseNote')
    map.uri(:in => DAMS, :to => 'licenseURI')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'Restriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'Permission')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.License]) if new?
    super
  end

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("uri", type: :text)] = uri
    solr_doc[ActiveFedora::SolrService.solr_name("note", type: :text)] = note

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
