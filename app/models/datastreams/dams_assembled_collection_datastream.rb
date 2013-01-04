class DamsAssembledCollectionDatastream < ActiveFedora::NokogiriDatastream
set_terminology do |t|
    t.root(:path=>"rdf:RDF", :xmlns=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", :namespace_prefix=>nil,"iso639"=>"http://id.loc.gov/vocabulary/iso639-1/","marcrel"=>"http://id.loc.gov/vocabulary/relators/","dams"=>"http://library.ucsd.edu/ontology/dams#","owl"=>"http://www.w3.org/2002/07/owl#","mads"=>"http://www.loc.gov/mads/rdf/v1#","damsrole"=>"http://library.ucsd.edu/ontology/role#","damsid"=>"http://library.ucsd.edu/ark:/20775/","xml"=>"http://www.w3.org/XML/1998/namespace")

    t.titleType(:path=>"dams:AssembledCollection/dams:title/dams:Title/dams:type", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.title(:path=>"dams:AssembledCollection/dams:title/dams:Title/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.beginDate(:path=>"dams:AssembledCollection/dams:date/dams:Date/dams:beginDate", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.language(:path=>"dams:AssembledCollection/dams:language/@rdf:resource", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.note(:path=>"dams:AssembledCollection/dams:note/dams:ScopeContentNote/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.noteDisplayLabel(:path=>"dams:AssembledCollection/dams:note/dams:ScopeContentNote/dams:displayLabel", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.noteType(:path=>"dams:AssembledCollection/dams:note/dams:ScopeContentNote/dams:type", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.relatedCollection(:path=>"dams:AssembledCollection/dams:relatedCollection/@rdf:resource", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.hasProvenanceCollection(:path=>"dams:AssembledCollection/dams:hasProvenanceCollection/@rdf:resource", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

    t.event(:path=>"dams:AssembledCollection/dams:event/@rdf:resource", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-s
yntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

 end # set_terminology
  def self.xml_template
    Nokogiri::XML::Document.parse(File.new(File.join(File.dirname(__FILE__),'..', '..', '..', 'lib', "damsAssembledCollection.xml")))
  end


end # class
