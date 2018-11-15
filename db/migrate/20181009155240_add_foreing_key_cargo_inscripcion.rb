class AddForeingKeyCargoInscripcion < ActiveRecord::Migration
  def up
  	
  	execute <<-SQL
	  	SET `SQL_SAFE_UPDATES` = 0;		
	SQL

	execute <<-SQL
		DELETE FROM `cargo_inscrip_docs`;
	SQL
	
	execute <<-SQL
		DELETE FROM `inscripcions`;
	SQL
	
	execute <<-SQL
		SET `SQL_SAFE_UPDATES` = 1;
	SQL
	

  	execute <<-SQL
	  	
		ALTER TABLE `cargo_inscrip_docs`
		ADD CONSTRAINT `cargo_inscripcion_id_fk`
		FOREIGN KEY (`inscripcion_id`) REFERENCES `inscripcions`(id)
		ON DELETE CASCADE;
	SQL
  end
end
