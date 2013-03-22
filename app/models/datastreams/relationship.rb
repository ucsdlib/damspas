class Relationship
    include ActiveFedora::RdfObject
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS)
      map.personalName(:in=> DAMS)
      map.corporateName(:in=> DAMS)
      map.role(:in=> DAMS)
    end

    def load
      if name.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(name.first.to_s)
        MadsPersonalName.find(md[1])
      elsif personalName.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(personalName.first.to_s)
        MadsPersonalName.find(md[1])
      elsif corporateName.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(corporateName.first.to_s)
        MadsCorporateName.find(md[1])
      end
    end
    
    def loadRole
      uri = role.first.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsRole.find(md[1])
      end
    end    
end