class Permission < ActiveRecord::Base
	has_many :roles, :foreign_key => 'permission_id', :class_name => 'RolePermissions'
	has_many :roles, :through => :role_permissions
end
