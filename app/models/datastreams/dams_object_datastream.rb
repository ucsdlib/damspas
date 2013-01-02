class DamsObjectDatastream < ActiveFedora::NokogiriDatastream
set_terminology do |t|
    t.root(:path=>"rdf:RDF", :xmlns=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", :namespace_prefix=>nil,"dams"=>"http://library.ucsd.edu/ontology/dams#","mads"=>"http://www.loc.gov/mads/rdf/v1#","damsid"=>"http://library.ucsd.edu/ark:/20775/","xml"=>"http://www.w3.org/XML/1998/namespace")

    t.arkUrl(:path=>"dams:Object/@rdf:about", :namespace_prefix=>nil, "r
df"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")
    
    t.title(:path=>"dams:Object/dams:title/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.relatedTitle(:path=>"dams:Object/dams:title/dams:relatedTitle/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.relatedTitleLang(:path=>"dams:Object/dams:title/dams:relatedTitle/rdf:value/@xml:lang", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#", "xml"=>"http://www.w3.org/XML/1998/namespace")

t.relatedTitleType(:path=>"dams:Object/dams:title/dams:relatedTitle/dams:type", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.beginDate(:path=>"dams:Object/dams:date/dams:beginDate", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.endDate(:path=>"dams:Object/dams:date/dams:endDate", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.date(:path=>"dams:Object/dams:date/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

t.languageId(:path=>"dams:Object/dams:language/@rdf:resource", :namespace_prefix=>nil, "r
df"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")

 end # set_terminology
  def self.xml_template
    Nokogiri::XML::Document.parse(File.new(File.join(File.dirname(__FILE__),'..', '..', '..', 'lib', "damsObjectModel.xml")))
  end


end # class
