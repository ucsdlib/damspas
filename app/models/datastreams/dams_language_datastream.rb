class DamsLanguageDatastream < ActiveFedora::NokogiriDatastream
set_terminology do |t|
    t.root(:path=>"rdf:RDF", :xmlns=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", :namespace_prefix=>nil,"iso639"=>"http://id.loc.gov/vocabulary/iso639-1/","marcrel"=>"http://id.loc.gov/vocabulary/relators/","dams"=>"http://library.ucsd.edu/ontology/dams#","owl"=>"http://www.w3.org/2002/07/owl#","mads"=>"http://www.loc.gov/mads/rdf/v1#","damsrole"=>"http://library.ucsd.edu/ontology/role#","damsid"=>"http://library.ucsd.edu/ark:/20775/","xml"=>"http://www.w3.org/XML/1998/namespace")

    t.code(:path=>"dams:Language/dams:code", :namespace_prefix=>nil, "r
df"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")
    
    t.language(:path=>"dams:Language/rdf:value", :namespace_prefix=>nil, "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "dams"=>"http://library.ucsd.edu/ontology/dams#")


 end # set_terminology
  def self.xml_template
    Nokogiri::XML::Document.parse(File.new(File.join(File.dirname(__FILE__),'..', '..', '..', 'lib', "damsLanguageModel.xml")))
  end


end # class
