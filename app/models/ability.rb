class Ability
 
  include CanCan::Ability
 
  def initialize(user, establecimiento_id)
    user ||= User.new # guest user
    unless user.nil?
      if user.role? :sadmin
      	can :manage, :all
      end
      user.roles.each do |ro|
        can do |action, subject_class, subject|
          ro.permissions.find_all_by_action([aliases_for_action(action), :manage].flatten).any? do |permission|
            if permission.action != "manage" then
              permission.subject_class == subject_class.to_s && permission.action == action.to_s
            else
              true
            end
          end
        end 
      end
    end
  end
end