require 'dams_vocabulary'
require 'mads_vocabulary'

module RDF
   # This enables RDF to respond_to? :value
   def self.value 
    self[:value]
   end
end


class DamsRdfDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.resource_type(:in => DAMS, :to => 'typeOfResource')
    map.title(:in => DAMS, :class_name => 'Description')
    map.collection(:in => DAMS)#, :class_name => 'AssembledCollection')
    map.subject(:in => DAMS, :class_name => 'Subject')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
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
  class Description
    include ActiveFedora::RdfObject
    map_predicates do |map|
      rdf_type DAMS.Description
      map.value(:in=> RDF) do |index|
	index.as :searchable
      end
    end
  end
  #class AssembledCollection
  #  include ActiveFedora::RdfObject
  #  map_predicates do |map|
  #    rdf_type DAMS.AssembledCollection
  #    map.scopeContentNote(:in=> DAMS, :class_name=>'ScopeContentNote') 
  #  end
  #  class ScopeContentNote
  #    include ActiveFedora::RdfObject
  #    map_predicates do |map|
  #      rdf_type DAMS.ScopeContentNote
  #      map.displayLabel(:in=> DAMS)
  #    end
  #  end
  #end

  class Subject
    include ActiveFedora::RdfObject
    map_predicates do |map|
      rdf_type MADS.ComplexSubject
      map.authoritativeLabel(:in=> MADS)
    end
  end

  class Relationship
    include ActiveFedora::RdfObject
    map_predicates do |map|
      rdf_type DAMS.Relationship
      map.name(:in=> DAMS)
    end
  end
end

