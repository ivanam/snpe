class CreateRoleAdminJuntaIfNotExist < ActiveRecord::Migration
  def up
  	
  	execute <<-SQL	
	  	INSERT INTO roles (description)
		SELECT * FROM (SELECT 'AdminJunta') AS tmp
		WHERE NOT EXISTS (
		    SELECT description FROM roles WHERE description = 'AdminJunta'
		) LIMIT 1;		
	SQL
	
  end
end
