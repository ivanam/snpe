class RolePermission < ActiveRecord::Base
	belongs_to :role, :foreign_key => 'role_id', :class_name => 'Role'
	belongs_to :permission, :foreign_key => 'regulator', :class_name => 'Permission'
end
