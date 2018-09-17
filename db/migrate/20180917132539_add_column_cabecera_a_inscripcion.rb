class AddColumnCabeceraAInscripcion < ActiveRecord::Migration
  def change
  	  	add_column :inscripcions, :cabecera, :integer
  end
end
