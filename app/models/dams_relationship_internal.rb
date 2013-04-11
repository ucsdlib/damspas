class DamsRelationshipInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS)
      map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')       
      map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')         
      map.role(:in=> DAMS, :class_name => 'DamsRoleInternal')
    end

	rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

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
      uri = role.first.pid
      if !uri.nil? && uri != ''
        DamsRole.find(uri)
      end
    end    

	def pid
	   rdf_subject.to_s.gsub(/.*\//,'')
	end
      
end