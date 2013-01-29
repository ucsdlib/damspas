class Ability 
  include Hydra::Ability
  def custom_permissions
  	if current_user.new_record?  #Anonymous user
  		can [:read], DamsObject
  		can [:read], DamsRepository
  		can [:read], DamsCopyright
  		can [:read], DamsLicense
  		can [:read], DamsStatute
  	else  #login user
    	can [:read, :create, :update], DamsObject
    	can [:read, :create, :update], DamsRepository
    	can [:read, :create, :update], DamsCopyright
    	can [:read, :create, :update], DamsLicense
    	can [:read, :create, :update], DamsStatute
    end
  end
end
