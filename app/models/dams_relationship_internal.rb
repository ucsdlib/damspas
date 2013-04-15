class DamsRelationshipInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS, :class_name => 'MadsNameInternal')
      map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')       
      map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')         
      map.role(:in=> DAMS, :class_name => 'DamsRoleInternal')
    end

	rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

    def load
      if !name.first.pid.nil?       
        MadsName.find(name.first.pid)
      elsif !personalName.first.pid.nil?
        MadsPersonalName.find(personalName.first.pid)
      elsif !corporateName.first.pid.nil?
        MadsCorporateName.find(corporateName.first.pid)
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