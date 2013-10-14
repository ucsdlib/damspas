module Dams

  def self.resolve_object(uri)
    pid = uri.to_s.gsub(/.*\//,'')
    if(pid.length > 0)
    	ActiveFedora::Base.load_instance_from_solr(pid)
    end
  end
end
