class DamsPersonDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
 end

  rdf_subject { |ds| RDF::URI.new(ds.about) }

  attr_reader :about

  def initialize(digital_object=nil, dsid=nil, options={})
    @about = options.delete(:about)
    super
  end

  after_initialize :type_resource
  def type_resource
    graph.insert([RDF::URI.new(about), RDF.type, DAMS.Object])
  end

  def content=(content)
    super
    @about = graph.statements.first.subject
  end
end

