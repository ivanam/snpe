class AgregarForameaEmInscripcion < ActiveRecord::Migration
  def change
  	execute <<-SQL
          UPDATE inscripcions
            set escuela_titular = null;              
        SQL
  	change_column :inscripcions, :escuela_titular, :integer
  end
end
