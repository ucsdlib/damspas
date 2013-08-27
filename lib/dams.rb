module Dams

  def self.resolve_object(uri)
    pid = uri.to_s.gsub(/.*\//,'') 
    ActiveFedora::Base.load_instance_from_solr(pid)
  end
end
