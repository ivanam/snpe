class Ability
 
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
    unless user.nil?
    	if user.confirmed?
		    if user.role? :admin
		    	can :manage, :all
		    elsif user.role? :user
		      can :manage, [Establecimiento]
		    end
		else
        	raise CanCan::AccessDenied.new("Debe registrar su mail!")	
        end
    end    
    can :read, [Establecimiento]
  end
end