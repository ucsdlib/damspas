class DamsRelationshipInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS, :class_name => 'MadsNameInternal')
      map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')       
      map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')         
      map.role(:in=> DAMS, :class_name => 'MadsAuthorityInternal')
    end

	rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}  

    def load
      if !name.first.nil? && !name.first.pid.nil? && !(name.first.pid.include? 'dams:')   
        MadsName.find(name.first.pid)
      elsif !personalName.first.nil? && !personalName.first.pid.nil? && !(personalName.first.pid.include? 'dams:')  
        MadsPersonalName.find(personalName.first.pid)
      elsif !corporateName.first.nil? && !corporateName.first.pid.nil? && !(corporateName.first.pid.include? 'dams:')  
        MadsCorporateName.find(corporateName.first.pid)
      end
    end
    
    def loadRole      
      if !role.first.nil? && role.first.pid != '' && !(role.first.pid.include? 'dams:')
        uri = role.first.pid
        MadsAuthority.find(uri)
      end
    end   
    
	def pid
	   rdf_subject.to_s.gsub(/.*\//,'')
	end
      
end
