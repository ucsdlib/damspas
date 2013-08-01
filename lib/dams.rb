module Dams
  autoload :ScopedUnitSearch, 'dams/scoped_unit_search'

  def self.resolve_object(uri)
    pid = uri.to_s.gsub(/.*\//,'') 
    ActiveFedora::Base.load_instance_from_solr(pid)
  end
end
