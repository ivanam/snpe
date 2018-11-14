class AgregarForeingKeyAAmbitoEnInscripcion < ActiveRecord::Migration
  
  def up
  	execute <<-SQL
          UPDATE inscripcions
            set ambito_id = null, establecimiento_id = null;              
        SQL
  	change_column :inscripcions, :ambito_id, :integer
  end

  def down
  	execute <<-SQL
          UPDATE inscripcions
            set ambito_id = null, establecimiento_id = null;              
    SQL
    change_column :inscripcions, :ambito_id, :string
  end
end
