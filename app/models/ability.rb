class Ability 
  include Hydra::Ability
  def custom_permissions
  	if current_user.new_record?  #Anonymous user
  		can [:read], DamsObject
  		can [:read], DamsUnit
  		can [:read], DamsCopyright
  		can [:read], DamsLicense
  		can [:read], DamsStatute
  		can [:read], DamsRole
  		can [:read], DamsLanguage
  		can [:read], DamsVocab
  		can [:read], DamsAssembledCollection
  	else  #login user
    	can [:read, :create, :update], DamsObject
    	can [:read, :create, :update], DamsUnit
    	can [:read, :create, :update], DamsCopyright
    	can [:read, :create, :update], DamsLicense
    	can [:read, :create, :update], DamsStatute
    	can [:read, :create, :update], DamsRole
    	can [:read, :create, :update], DamsLanguage
    	can [:read, :create, :update], DamsVocab
  		can [:read, :create, :update], DamsAssembledCollection
    end
  end
end
