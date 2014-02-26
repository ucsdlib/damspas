class Ability 
  include Hydra::Ability
  def custom_permissions

    can [:solr], :all
    def create_permissions
      #can :create, :all if user_groups.include? 'registered'
    end
    
    # Override create dams:Object for curator roles: dams-curator, dams-rci, dams-manager-admin etc.
    can :create, DamsObject do |obj|
    	result = false
        group_intersection = user_groups & Rails.configuration.curator_groups
        if(!group_intersection.empty?)
            result = true
            unit = obj.units
            if(!unit.nil? && !unit.group.blank?)
                unit_group = unit.group.first
                if !(user_groups.include?(Rails.configuration.super_role) || user_groups.include?(unit_group))
                    result = false;
                end
                logger.debug("[CANCAN] #{unit_group} DamsObject creation decision: #{result}")
            end
        end
        logger.debug("[CANCAN] DamsObject creation decision: #{result}: #{obj.units}")
        result
    end
 
 	#### Override create DamsProvenanceCollection for curator roles only ####
    can :create, DamsProvenanceCollection do |obj|
    	result = false
        group_intersection = user_groups & Rails.configuration.curator_groups
        if(!group_intersection.empty?)
            result = true
            unit = obj.damsMetadata.load_unit obj.damsMetadata.unit
            if(!unit.nil? && !unit.group.blank?)
                unit_group = unit.group.first
                if !(user_groups.include?(Rails.configuration.super_role) || user_groups.include?(unit_group))
                    result = false;
                end
                logger.debug("[CANCAN] #{unit_group} DamsProvenanceCollection creation decision: #{result}")
            end
        end
        logger.debug("[CANCAN] DamsProvenanceCollection creation decision: #{result}: #{obj.damsMetadata.unit}")
        result
    end
    
 	##### Override create DamsProvenanceCollectionPart for curator roles only ####
    can :create, DamsProvenanceCollectionPart do |obj|
    	result = false
        group_intersection = user_groups & Rails.configuration.curator_groups
        if(!group_intersection.empty?)
            result = true
            unit = obj.damsMetadata.load_unit obj.damsMetadata.unit
            if(!unit.nil? && !unit.group.blank?)
                unit_group = unit.group.first
                if !(user_groups.include?(Rails.configuration.super_role) || user_groups.include?(unit_group))
                    result = false;
                end
                logger.debug("[CANCAN] #{unit_group} DamsProvenanceCollectionPart creation decision: #{result}")
            end
        end
        logger.debug("[CANCAN] DamsProvenanceCollectionPart creation decision: #{result}: #{obj.damsMetadata.unit}")
        result
    end

 	#### Override create DamsAssembledCollection for curator roles only ####
    can :create, DamsAssembledCollection do |obj|
    	result = false
        group_intersection = user_groups & Rails.configuration.curator_groups
        if(!group_intersection.empty?)
            result = true
            unit = obj.damsMetadata.load_unit obj.damsMetadata.unit
            if(!unit.nil? && !unit.group.blank?)
                unit_group = unit.group.first
                if !(user_groups.include?(Rails.configuration.super_role) || user_groups.include?(unit_group))
                    result = false;
                end
                logger.debug("[CANCAN] #{unit_group} DamsAssembledCollection creation decision: #{result}")
            end
        end
        logger.debug("[CANCAN] DamsAssembledCollection creation decision: #{result}: #{obj.damsMetadata.unit}")
        result
    end

	#### Override to allow read-access to all other non-DamsObject, non-collections classes for roles other than the super role dams-manager-admin####	
    group_intersection = user_groups & Rails.configuration.curator_groups
    if current_user.new_record? || current_user.anonymous || group_intersection.empty? # anonymous/non-curator
      can [:read], DamsCopyright
      can [:read], DamsOtherRight
      can [:read], DamsLicense
      can [:read], DamsStatute
      can [:read], DamsSourceCapture
      can [:read], DamsCartographics
      can [:read], DamsCulturalContext
      can [:read], DamsTechnique
      can [:read], DamsIconography
      can [:read], DamsBuiltWorkPlace
      can [:read], DamsScientificName
      can [:read], DamsStylePeriod
      can [:read], MadsPersonalName
      can [:read], MadsComplexSubject
      can [:read], MadsTopic
      can [:read], MadsTemporal
      can [:read], MadsFamilyName
      can [:read], MadsCorporateName      
      can [:read], MadsConferenceName   
      can [:read], MadsName
      can [:read], MadsOccupation
      can [:read], MadsGenreForm
      can [:read], MadsGeographic
      can [:read], MadsScheme
      can [:read], MadsAuthority
      can [:read], MadsLanguage
      can [:read], MadsVariant
      cannot [:create], DamsObject
      cannot [:create], DamsAssembledCollection
      cannot [:create], DamsProvenanceCollection
      cannot [:create], DamsProvenanceCollectionPart
      cannot [:create], Page
    else  # curators
      can [:read], DamsAssembledCollection
      can [:read], DamsProvenanceCollection
      can [:read], DamsProvenanceCollectionPart
      can [:read, :create, :update], DamsFunction
      can [:read, :create, :update], DamsCulturalContext
      can [:read, :create, :update], DamsTechnique
      can [:read, :create, :update], DamsIconography
      can [:read, :create, :update], DamsBuiltWorkPlace
      can [:read, :create, :update], DamsScientificName
      can [:read, :create, :update], DamsStylePeriod
      can [:read, :create, :update], DamsCopyright
      can [:read, :create, :update], DamsOtherRight
      can [:read, :create, :update], DamsLicense
      can [:read, :create, :update], DamsStatute
      can [:read, :create, :update], DamsSourceCapture
      can [:read, :create, :update], DamsCartographics
      can [:read, :create, :update], MadsPersonalName
      can [:read, :create, :update], MadsFamilyName
      can [:read, :create, :update], MadsCorporateName      
      can [:read, :create, :update], MadsConferenceName    
      can [:read, :create, :update], MadsName    
      can [:read, :create, :update], SolrDocument
      can [:read, :create, :update], MadsComplexSubject
      can [:read, :create, :update], MadsTopic
      can [:read, :create, :update], MadsTemporal
      can [:read, :create, :update], MadsOccupation
      can [:read, :create, :update], MadsGenreForm
      can [:read, :create, :update], MadsGeographic      
      can [:read, :create, :update], MadsScheme
      can [:read, :create, :update], MadsAuthority
      can [:read, :create, :update], MadsLanguage
      can [:read, :create, :update], MadsVariant
      can [:read, :create, :update, :destroy], Page
    end

    # DamsUnit is a special case: super-user only
    if user_groups.include?(Rails.configuration.super_role)
      can [:read, :create, :update], DamsUnit
    else
      can [:read], DamsUnit
    end
  end
end
